#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $0 swap [--dry-run]" >&2
}

if [[ ${1:-} != swap || $# -gt 2 ]]; then
    usage
    exit 2
fi
dry_run=false
case "${2:-}" in
    '') ;;
    --dry-run) dry_run=true ;;
    *) usage; exit 2 ;;
esac

# Capture both original assignments before moving either workspace.
visible=$(aerospace list-workspaces --monitor all --visible --format '%{monitor-id}%{tab}%{workspace}')
monitors=()
workspaces=()
while IFS=$'\t' read -r monitor workspace; do
    [[ -n "$monitor" && -n "$workspace" ]] || continue
    monitors+=("$monitor")
    workspaces+=("$workspace")
done <<< "$visible"

if [[ ${#monitors[@]} -ne 2 ]]; then
    echo 'swap requires exactly two monitors with visible workspaces.' >&2
    exit 1
fi
focused=$(aerospace list-workspaces --focused)

run() {
    if "$dry_run"; then
        printf '%q ' "$@"
        printf '\n'
    else
        "$@"
    fi
}

run aerospace move-workspace-to-monitor --workspace "${workspaces[0]}" "${monitors[1]}"
if ! run aerospace move-workspace-to-monitor --workspace "${workspaces[1]}" "${monitors[0]}"; then
    # Attempt to restore the original state if the second move fails.
    aerospace move-workspace-to-monitor --workspace "${workspaces[0]}" "${monitors[0]}" || true
    aerospace workspace "$focused" || true
    exit 1
fi
run aerospace workspace "$focused"
