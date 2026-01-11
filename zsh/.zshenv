# Minimal environment for all zsh invocations

# Common environment used by shells and scripts
export NVM_DIR="$HOME/.nvm"

# Cargo environment (preserve existing behavior if present)
[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
