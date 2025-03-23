#!/bin/bash
git status --no-renames | awk '
function strip(str) {
    gsub(/^\s+|\s+$/, "", str)
    return str
}

/Changes to be committed:/,/Changes not staged for commit:/{
    if ($0 ~ /modified/) {
        print substr($0,14)
    }
    if ($0 ~ /new file/) {
        print substr($0,14)
    }
}
/Changes not staged for commit:/,/Untracked files:/{
    if ($0 ~ /modified/) {
        print substr($0,14)
    }
}
/Untracked files:/{
    uflag = 1
}
uflag {
    lnum++
    if (lnum >= 3) {
        print strip($0)
    }
    if ($0 ~ /^$/) {
        exit
    }
}
'
