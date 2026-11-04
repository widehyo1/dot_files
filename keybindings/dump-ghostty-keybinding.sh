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

ghostty +list-keybinds --plain | "$HOME/uv_toolbox/.venv/bin/python" -c '
import csv
import re
import sys

writer = csv.writer(sys.stdout, delimiter="\t", lineterminator="\n", quoting=csv.QUOTE_NONE, quotechar=None)
writer.writerow(["key", "command"])
for line in sys.stdin:
    match = re.fullmatch(r"keybind = (.+?)=([a-z_].*)", line.rstrip("\n"))
    if match:
        writer.writerow(match.groups())
' | tee "$HOME/keybindings/ghostty-keybinding.tsv"
