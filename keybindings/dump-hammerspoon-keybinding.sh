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
/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs -c 'printKeybindings()' | tee ~/keybindings/hammerspoon-keybindings.tsv
