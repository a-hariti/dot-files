#!/usr/bin/env sh

# place keybord remapings to be ran on startup
ln -sf ~/.dotfiles/keymapping.xml ~/Library/LaunchAgents/com.example.KeyRemapping.plist

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
