#!/usr/bin/env bash

# remap keyboard keys on mac
[[ "$(uname -s)" = "Darwin" ]] && stow mac-mappings --target ~/Library/LaunchAgents

# set up zgen to manage zsh plugins
if [[ ! -d "${HOME}/.zgen" ]]; then
    git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

stow --target ~ git zsh tmux nvim alacritty
