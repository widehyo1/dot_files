#!/usr/bin/env bash
set -euo pipefail

silent=false
for arg in "$@"; do
    case "$arg" in
        --silent) silent=true ;;
        -h|--help) echo "Usage: $0 [--silent]"; exit 0 ;;
        *) echo "Unknown option: $arg" >&2; exit 2 ;;
    esac
done
# Keep writing output files while suppressing only stdout.
if "$silent"; then
    exec > /dev/null
fi

output_dir="$HOME/keybindings"

aerospace config --get mode.main.binding --json > "$output_dir/aerospace-main-keybinding.json"
aerospace config --get mode.service.binding --json > "$output_dir/aerospace-service-keybinding.json"

jq -sr '
  (["mode", "key", "command"] | @tsv),
  (to_entries[] |
    (if .key == 0 then "main" else "service" end) as $mode |
    .value | to_entries[] |
    [$mode, .key, .value] | @tsv)
' "$output_dir/aerospace-main-keybinding.json" \
  "$output_dir/aerospace-service-keybinding.json" \
  | tee "$output_dir/aerospace-keybindings.tsv"
