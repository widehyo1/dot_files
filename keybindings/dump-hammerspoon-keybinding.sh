#!/usr/bin/env bash
/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs -c 'printKeybindings()' | tee ~/keybindings/hammerspoon-keybindings.tsv
