#!/bin/bash
PS4='+ ${BASH_SOURCE}:${LINENO}: ' \
bash --noprofile --norc -ic 'set -x; source ~/.bashrc; set +x' \
2>bashrc.trac
