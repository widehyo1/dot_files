#!/usr/bin/env bash
set -euo pipefail

ghostty +list-keybinds --plain | python3 -c '
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
