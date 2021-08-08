#!/usr/bin/env bash

# remap keyboard keys on mac
stow -Rv -t ~/LaunchAgents mac-mappings

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
