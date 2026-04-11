#!/bin/bash
set -uo pipefail

DOT_FILES_DIR="$HOME/gitclone/dot_files"
BASH_CONFIG_DIR="$HOME/.config/bash"
SECURITYENV_FILE="$BASH_CONFIG_DIR/securityenv"
SECURITYENV_BAK="$BASH_CONFIG_DIR/securityenv_bak"

mkdir -p ~/.vim
echo stow dot_vim -t ~/.vim --adopt
stow dot_vim -t ~/.vim --adopt
echo cp "$DOT_FILES_DIR"/dot_vimrc ~/.vimrc
cp "$DOT_FILES_DIR"/dot_vimrc ~/.vimrc
echo cp "$DOT_FILES_DIR"/dot_inputrc ~/.inputrc
cp "$DOT_FILES_DIR"/dot_inputrc ~/.inputrc
echo cp "$DOT_FILES_DIR"/dot_gitconfig ~/.gitconfig
cp "$DOT_FILES_DIR"/dot_gitconfig ~/.gitconfig
mkdir -p ~/.cli
echo stow dot_cli -t ~/.cli --adopt
stow dot_cli -t ~/.cli --adopt

mkdir -p "$BASH_CONFIG_DIR" 
echo 'cd "$DOT_FILES_DIR"/dot_config && stow bash -t "$BASH_CONFIG_DIR" --adopt'
cd "$DOT_FILES_DIR"/dot_config && stow bash -t "$BASH_CONFIG_DIR" --adopt
echo cp ~/.bashrc ~/.bashrc_bak
cp ~/.bashrc ~/.bashrc_bak
echo cp "$SECURITYENV_FILE" "$SECURITYENV_BAK"
cp "$SECURITYENV_FILE" "$SECURITYENV_BAK"
echo cp "$DOT_FILES_DIR"/dot_bashrc ~/.bashrc
cp "$DOT_FILES_DIR"/dot_bashrc ~/.bashrc
