#!/bin/bash
set -uo pipefail

DOT_FILES_DIR="$HOME/gitclone/dot_files"
BASH_CONFIG_DIR="$HOME/.config/bash"
SECURITYENV_FILE="$BASH_CONFIG_DIR/securityenv"
SECURITYENV_BAK="$BASH_CONFIG_DIR/securityenv_bak"

mkdir -p ~/.vim
echo tar -C "$DOT_FILES_DIR"/dot_vim -cf - . | tar -C ~/.vim -xf -
tar -C "$DOT_FILES_DIR"/dot_vim -cf - . | tar -C ~/.vim -xf -
echo cp "$DOT_FILES_DIR"/dot_vimrc ~/.vimrc
cp "$DOT_FILES_DIR"/dot_vimrc ~/.vimrc
echo cp "$DOT_FILES_DIR"/dot_inputrc ~/.inputrc
cp "$DOT_FILES_DIR"/dot_inputrc ~/.inputrc
echo cp "$DOT_FILES_DIR"/dot_gitconfig ~/.gitconfig
cp "$DOT_FILES_DIR"/dot_gitconfig ~/.gitconfig
mkdir -p ~/.cli
echo tar -C "$DOT_FILES_DIR"/dot_cli -cf - . | tar -C ~/.cli -xf -
tar -C "$DOT_FILES_DIR"/dot_cli -cf - . | tar -C ~/.cli -xf -

mkdir -p "$BASH_CONFIG_DIR" 
echo tar -C "$DOT_FILES_DIR"/dot_config/bash -cf - . | tar -C "$BASH_CONFIG_DIR" -xf -
tar -C "$DOT_FILES_DIR"/dot_config/bash -cf - . | tar -C "$BASH_CONFIG_DIR" -xf -
echo cp ~/.bashrc ~/.bashrc_bak
cp ~/.bashrc ~/.bashrc_bak
echo cp "$SECURITYENV_FILE" "$SECURITYENV_BAK"
cp "$SECURITYENV_FILE" "$SECURITYENV_BAK"
echo cp "$DOT_FILES_DIR"/dot_bashrc ~/.bashrc
cp "$DOT_FILES_DIR"/dot_bashrc ~/.bashrc
