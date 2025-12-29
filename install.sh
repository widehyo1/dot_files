#!/bin/bash
set -ufo pipefail

DOT_FILES_DIR="$HOME/gitclone/dot_files"
BASH_CONFIG_DIR="$HOME/.config/bash"
SECURITYENV_FILE="$BASH_CONFIG_DIR/securityenv"
SECURITYENV_BAK="$BASH_CONFIG_DIR/securityenv_bak"

echo cp -r "$DOT_FILES_DIR"/dot_vim ~/.vim
cp -r "$DOT_FILES_DIR"/dot_vim/ ~/.vim/
echo cp "$DOT_FILES_DIR"/dot_vimrc ~/.vimrc
cp "$DOT_FILES_DIR"/dot_vimrc ~/.vimrc
echo cp "$DOT_FILES_DIR"/dot_inputrc ~/.inputrc
cp "$DOT_FILES_DIR"/dot_inputrc ~/.inputrc
echo cp "$DOT_FILES_DIR"/dot_gitconfig ~/.gitconfig
cp "$DOT_FILES_DIR"/dot_gitconfig ~/.gitconfig
echo cp -r "$DOT_FILES_DIR"/dot_cli ~/.cli
cp -r "$DOT_FILES_DIR"/dot_cli ~/.cli

echo cp -r "$DOT_FILES_DIR"/dot_config/bash "$BASH_CONFIG_DIR"
cp -r "$DOT_FILES_DIR"/dot_config/bash/ "$BASH_CONFIG_DIR/"
echo cp ~/.bashrc ~/.bashrc_bak
cp ~/.bashrc ~/.bashrc_bak
echo cp "$SECURITYENV_FILE" "$SECURITYENV_BAK"
cp "$SECURITYENV_FILE" "$SECURITYENV_BAK"
echo cp "$DOT_FILES_DIR"/dot_bashrc ~/.bashrc
cp "$DOT_FILES_DIR"/dot_bashrc ~/.bashrc
