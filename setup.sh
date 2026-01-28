#!/usr/bin/env bash

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# remap keyboard keys on mac
[[ "$(uname -s)" = "Darwin" ]] && stow mac-mappings --target ~/Library/LaunchAgents

# set up zgen to manage zsh plugins
if [[ ! -d "${HOME}/.zgen" ]]; then
    git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

stow --target ~ git zsh tmux nvim alacritty ghostty bin

# Zed (stow into .config/zed)
mkdir -p ~/.config/zed
stow --target ~/.config/zed zed
