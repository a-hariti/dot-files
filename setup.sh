#!/usr/bin/env bash

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# set up zgen to manage zsh plugins
if [[ ! -d "${HOME}/.zgen" ]]; then
    git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

stow --target ~ git zsh tmux

# Alacritty (stow into .config/alacritty)
mkdir -p ~/.config/alacritty
stow --target ~/.config/alacritty alacritty

# Ghostty (stow into .config/ghostty)
mkdir -p ~/.config/ghostty
stow --target ~/.config/ghostty ghostty

# Neovim (stow into .config/nvim)
mkdir -p ~/.config/nvim
stow --target ~/.config/nvim nvim

# local tools (symlink into ~/.local/bin)
mkdir -p ~/.local/bin
stow --target ~/.local/bin tools

# Zed (stow into .config/zed)
mkdir -p ~/.config/zed
stow --target ~/.config/zed zed

# macOS specific setup
if [[ "$(uname -s)" = "Darwin" ]]; then
    # remap keyboard keys
    stow mac-mappings --target ~/Library/LaunchAgents

    # Rectangle configuration
    if [[ -d "/Applications/Rectangle.app" ]]; then
        RECTANGLE_DIR="$HOME/Library/Application Support/Rectangle"
        mkdir -p "$RECTANGLE_DIR"
        ln -sf "$PWD/RectangleConfig.json" "$RECTANGLE_DIR/RectangleConfig.json"
        # Restart Rectangle to trigger import
        if pgrep -x "Rectangle" >/dev/null; then
            killall Rectangle 2>/dev/null
            while pgrep -x "Rectangle" >/dev/null; do sleep 0.1; done
            open -a Rectangle 2>/dev/null
        fi
    fi
fi
