#!/bin/bash
git reflog | awk 'NR == 2{ printf "git difft %s..HEAD\n", $1 }' | bash
