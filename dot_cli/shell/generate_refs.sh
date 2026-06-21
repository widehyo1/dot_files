#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s [--outdir DIR|--outdir=DIR] [input-file]\n' "${0##*/}"
}

die() {
  printf '%s\n' "$*" >&2
  exit 1
}

command -v jq >/dev/null || die 'jq is required'
command -v sqlite3 >/dev/null || die 'sqlite3 is required'
command -v realpath >/dev/null || die 'realpath is required'

outdir=refs
input_file=
while (($#)); do
  case $1 in
    --outdir)
      (($# >= 2)) || die '--outdir requires a directory'
      outdir=$2
      shift 2
      ;;
    --outdir=*)
      outdir=${1#*=}
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    -*)
      die "unknown option: $1"
      ;;
    *)
      [ -z "$input_file" ] || die 'only one input file is allowed'
      input_file=$1
      shift
      ;;
  esac
done

case $outdir in
  ''|/|.|..)
    die "refusing unsafe output directory: $outdir"
    ;;
esac

source_file=
temporary_files=()
cleanup() {
  local file
  for file in "${temporary_files[@]}"; do
    rm -f -- "$file"
  done
}
trap cleanup EXIT

if [ -n "$input_file" ]; then
  [ -r "$input_file" ] || die "cannot read input file: $input_file"
  source_file=$input_file
  base=$(basename -- "$input_file")
  base=${base%.jsonl}
  base=${base%.json}
  file_mode=1
else
  source_file=$(mktemp)
  temporary_files+=("$source_file")
  cat >"$source_file"
  base=root
  file_mode=0
fi

normalized=$(mktemp)
records=$(mktemp)
sql_file=$(mktemp)
temporary_files+=("$normalized" "$records" "$sql_file")

if [[ $source_file == *.jsonl ]]; then
  root_key=$([ "$file_mode" -eq 1 ] && printf '%s_ref' "$base" || printf 'root_item')
  jq -cs --arg root "$root_key" '
    if length == 0 then
      error("input is empty")
    elif all(.[]; type == "object") then
      [to_entries[] | {path: [$root], index: .key, collection: true, value: .value}]
    else
      error("JSONL values must be objects")
    end
  ' "$source_file" >"$normalized" || die 'invalid JSONL input'
else
  jq -s --arg root_object "$([ "$file_mode" -eq 1 ] && printf '%s' "$base" || printf 'root')" \
    --arg root_collection "$([ "$file_mode" -eq 1 ] && printf '%s_ref' "$base" || printf 'root_item')" '
    if length == 0 then
      error("input is empty")
    elif length == 1 then
      .[0] as $value
      | if ($value | type) == "object" then
          [{path: [$root_object], value: $value}]
        elif ($value | type) == "array" then
          if ($value | all(.[]; type == "object")) then
            [$value | to_entries[] | {path: [$root_collection], index: .key, collection: true, value: .value}]
          else
            error("top-level array values must be objects")
          end
        else
          error("top-level JSON value must be an object or array")
        end
    elif all(.[]; type == "object") then
      [to_entries[] | {path: [$root_collection], index: .key, collection: true, value: .value}]
    else
      error("top-level JSON values must be objects")
    end
  ' "$source_file" >"$normalized" || die 'invalid JSON input'
fi

rm -rf -- "$outdir"
mkdir -p -- "$outdir"

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
jq -c --arg outdir "$outdir" -f "$script_dir/generate_refs.jq" "$normalized" >"$records" \
  || die 'schema generation failed'

cat "$records"

database="$outdir/schemas.sqlite"
printf '%s\n' \
  'BEGIN;' \
  'CREATE TABLE schema_paths (schema_path TEXT NOT NULL, object_path TEXT PRIMARY KEY);' \
  'CREATE TABLE array_index_refs (array_path TEXT NOT NULL, array_index INTEGER NOT NULL, schema_path TEXT NOT NULL, PRIMARY KEY (array_path, array_index));' \
  >"$sql_file"

sql_quote() {
  local value=$1
  printf "'%s'" "${value//\'/\'\'}"
}

declare -A made_directories=()
ensure_parent() {
  local directory
  directory=$(dirname -- "$1")
  if [[ ! ${made_directories[$directory]+_} ]]; then
    mkdir -p -- "$directory"
    made_directories[$directory]=1
  fi
}

while IFS=$'\t' read -r canonical schema_json object_path; do
  ensure_parent "$canonical"
  printf '%s\n' "$schema_json" >"$canonical"
  if [ "$object_path" != "$canonical" ]; then
    ensure_parent "$object_path"
    target=$(realpath --relative-to="$(dirname -- "$object_path")" "$canonical")
    ln -sfn -- "$target" "$object_path"
  fi
  canonical_sql=$(sql_quote "$canonical")
  object_sql=$(sql_quote "$object_path")
  printf 'INSERT INTO schema_paths(schema_path, object_path) VALUES (%s, %s) ON CONFLICT(object_path) DO UPDATE SET schema_path=excluded.schema_path;\n' \
    "$canonical_sql" "$object_sql" >>"$sql_file"
done < <(jq -r '. as $record | $record.object_paths[] | [$record.schema_path, ($record.schema | tojson), .] | @tsv' "$records")

while IFS=$'\t' read -r array_path array_index schema_path; do
  array_path_sql=$(sql_quote "$array_path")
  schema_path_sql=$(sql_quote "$schema_path")
  printf 'INSERT INTO array_index_refs(array_path, array_index, schema_path) VALUES (%s, %s, %s) ON CONFLICT(array_path, array_index) DO UPDATE SET schema_path=excluded.schema_path;\n' \
    "$array_path_sql" "$array_index" "$schema_path_sql" >>"$sql_file"
done < <(jq -r 'select(has("array_parent")) | . as $record | $record.array_indexes[] | [$record.array_parent, ., $record.schema_path] | @tsv' "$records")

printf '%s\n' 'COMMIT;' >>"$sql_file"
sqlite3 "$database" <"$sql_file"
