#!/usr/bin/env bash

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# set up zgenom to manage zsh plugins
if [[ ! -d "${HOME}/.zgenom" ]]; then
    git clone https://github.com/jandamm/zgenom.git "${HOME}/.zgenom"
fi

stow --target ~ git zsh tmux

ensure_dir() {
    local dir="$1"
    # Remove broken symlinks so mkdir can succeed.
    if [[ -L "$dir" && ! -e "$dir" ]]; then
        rm -f "$dir"
    fi
    mkdir -p "$dir"
}

# Ensure base config dir exists
ensure_dir ~/.config

# Alacritty (stow into .config/alacritty)
ensure_dir ~/.config/alacritty
stow --target ~/.config/alacritty alacritty

# Ghostty (stow into .config/ghostty)
ensure_dir ~/.config/ghostty
stow --target ~/.config/ghostty ghostty

# Neovim (stow into .config/nvim)
ensure_dir ~/.config/nvim
stow --target ~/.config/nvim nvim

# local tools (symlink into ~/.local/bin)
ensure_dir ~/.local/bin
stow --target ~/.local/bin tools

# Zed (stow into .config/zed)
ensure_dir ~/.config/zed
stow --target ~/.config/zed zed

# Presenterm (stow into .config/presenterm)
ensure_dir ~/.config/presenterm
stow --target ~/.config/presenterm presenterm

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

echo "✔︎ dot files setup complete"
