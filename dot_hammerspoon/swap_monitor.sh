#!/bin/bash
/opt/homebrew/bin/aerospace list-workspaces --monitor all --visible --format '%{monitor-id} %{workspace} %{workspace-is-focused}' | awk -f /Users/widehyo/.hammerspoon/swap_monitor.awk | bash
