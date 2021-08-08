#!/usr/bin/env bash

# remap keyboard keys on mac
# todo: skip on linux
stow -Rv -t ~/Library/LaunchAgents mac-mappings

# make sure the neovim directory is there
mkdir -p ~/.config/nvim

home_dot_files=(
    git
    zsh
    tmux
)

dot_config_dot_files=(
    nvim
    alacritty
)

for item in $home_dot_files; do
    stow -vR -t ~ $item
done


for item in $dot_config_dot_files; do
    stow -vR -t ~/.config/$item $item
done
