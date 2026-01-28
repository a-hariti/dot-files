# uncomment to enable profiling
# zmodload zsh/zprof

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd

zstyle :compinstall filename "$HOME/.zshrc"

export ZSH_DISABLE_COMPFIX=true
export ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump-${HOST}-${ZSH_VERSION}"

fpath=("$HOME/.zsh/completions" "$HOME/.bun" $fpath)

# Group all completion zstyles
zstyle ':completion:*' \
    use-cache on \
    cache-path "$HOME/.zcompcache" \
    rehash true \
    matcher-list 'm:{a-zA-Z}={A-Za-z}'

export KEYTIMEOUT=1

# Disable OMZ auto-update checks at startup
# zstyle ':omz:update' mode disabled

alias v=nvim
alias mv='mv -i'
alias gs='git status'

# Use the powerful zsh-contrib 'extract' function
autoload -Uz extract

# colorful man pages
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
        LESS_TERMCAP_me=$'\e[0m' \
        LESS_TERMCAP_se=$'\e[0m' \
        LESS_TERMCAP_so=$'\e[01;44;33m' \
        LESS_TERMCAP_ue=$'\e[00m' \
        LESS_TERMCAP_us=$'\e[01;32m' \
        command man "$@"
}

s() {
    # default to "start" script
    local script="start"
    if [ -f "package.json" ]; then
        if jq -e '.scripts.dev' package.json >/dev/null; then
            script="dev"
        fi
    else
        echo "No package.json file found. Exiting..."
        return 1 # Use 'return' instead of 'exit' to not kill the shell
    fi

    # define binary to run (npm or yarn based on lock file)
    local bin="npm"
    if [ -f "yarn.lock" ]; then
        bin="yarn"
    fi
    # Redundant 'else' block removed

    # run the script
    "$bin" run "$script" "$@"
}

# Load zgenom
source "${HOME}/.zgenom/zgenom.zsh"

# if the init script doesn't exist
if ! zgenom saved; then
    echo "Creating a zgenom save"

    # specify plugins here
    zgenom oh-my-zsh
    zgenom oh-my-zsh themes/arrow
    zgenom oh-my-zsh plugins/z
    zgenom oh-my-zsh plugins/git
    zgenom oh-my-zsh plugins/docker
    zgenom oh-my-zsh plugins/yarn

    # ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
    zgenom load zsh-users/zsh-syntax-highlighting
    zgenom load zsh-users/zsh-autosuggestions
    zgenom load popstas/zsh-command-time

    # generate the init script from plugins above
    zgenom save
fi

# vim mode
bindkey -v
# fix backspace not working after going to normal mode and back
bindkey "^?" backward-delete-char

# Activate virtual env and save the path as a tmux variable,
# so that new panes/windows can re-activate as necessary
sv() {
    # source venv/bin/activate &&  # commented out by conda initialize
    tmux set-environment VIRTUAL_ENV $VIRTUAL_ENV
}

# Simple completion init (single pass for reliability)
autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"

# --- Fzf Configuration ---
# Use fd as the default fzf finder
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Custom fzf completion generators using fd
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Load fzf shell integrations
if [[ -o interactive ]]; then
  FZF_SHELL_DIR="/opt/homebrew/opt/fzf/shell"
  if [[ -f "$FZF_SHELL_DIR/key-bindings.zsh" ]]; then
    source "$FZF_SHELL_DIR/key-bindings.zsh"
  fi
  if [[ -f "$FZF_SHELL_DIR/completion.zsh" ]]; then
    source "$FZF_SHELL_DIR/completion.zsh"
  fi
fi

# Lazy-load rbenv and friends on first use
__nvm_lazy_source() {
  : "${NVM_DIR:=$HOME/.nvm}"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}
__rbenv_lazy_init() {
  if command -v rbenv >/dev/null 2>&1; then
    unset -f rbenv ruby gem bundle rake rails irb 2>/dev/null
    eval "$(rbenv init - zsh 2>/dev/null)"
  fi
}
__lazy_wrap() {
  local init_func="$1"; shift
  for cmd in "$@"; do
    eval "
      $cmd() {
        unset -f $cmd
        $init_func
        command $cmd \"\$@\"
      }
    "
  done
}
__lazy_wrap __rbenv_lazy_init rbenv ruby gem bundle rake rails irb
__lazy_wrap __nvm_lazy_source nvm node npm npx

# uncomment to enable profiling
# zprof

# Amp CLI
export PATH="$HOME/.amp/bin:$PATH"

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# opencode
export PATH=$HOME/.opencode/bin:$PATH
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
