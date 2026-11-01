#!/usr/bin/env bash
set -euo pipefail

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
