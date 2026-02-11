# Locale
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"


# Homebrew environment (if installed)
if command -v /opt/homebrew/bin/brew >/dev/null 2>&1; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Editors
export VISUAL=nvim
export EDITOR="$VISUAL"

# Languages / toolchains
export GOPATH="$HOME/go"
export BUN_INSTALL="$HOME/.bun"
export GEM_HOME="$HOME/.gem"
export NVM_DIR="$HOME/.nvm"

# Helper to prepend to PATH if directory exists and not already present
_path_prepend() { [ -d "$1" ] && case ":$PATH:" in *":$1:"*) ;; *) PATH="$1:$PATH" ;; esac; }

# Core PATH entries
_path_prepend "$HOME/.cargo/bin"
_path_prepend "/usr/local/go/bin"
_path_prepend "$GOPATH/bin"
_path_prepend "$HOME/.scripts"
_path_prepend "$HOME/.local/bin"

# Package managers / libs
_path_prepend "$BUN_INSTALL/bin"
_path_prepend "/opt/homebrew/opt/ruby/bin"
_path_prepend "/opt/homebrew/opt/libpq/bin"



