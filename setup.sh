#!/usr/bin/env bash

# remap keyboard keys on mac
[[ "$(uname -s)" = "Darwin" ]] && stow -Rv -t ~/Library/LaunchAgents mac-mappings

# set up zgen to manage zsh plugins
git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
stow -vR -t ~ zsh

# make sure the neovim and alacritty directories are there
mkdir -p ~/.config/{nvim,alacritty}

home_dot_files=( git tmux zsh )

dot_config_dot_files=( nvim alacritty )

for item in ${home_dot_files[@]}; do
    stow -vR -t ~ $item
done


for item in ${dot_config_dot_files[@]}; do
    stow -vR -t ~/.config/$item $item
done
