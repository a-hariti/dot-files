# uncomment to enable profiling
# zmodload zsh/zprof

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd

zstyle :compinstall filename '/home/abdellah/.zshrc'

# Speed up completions: cache results and avoid slow compaudit fixes
export ZSH_DISABLE_COMPFIX=true
export ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump-${HOST}-${ZSH_VERSION}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"

# capitalization agnostique completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

export KEYTIMEOUT=1

alias v=nvim
alias mv='mv -i'

function extract {
    echo Extracting $1 ...
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1  ;;
            *.tar.gz)    tar xzf $1  ;;
            *.bz2)       bunzip2 $1  ;;
            *.rar)       rar x $1    ;;
            *.gz)        gunzip $1   ;;
            *.tar)       tar xf $1   ;;
            *.tbz2)      tar xjf $1  ;;
            *.tgz)       tar xzf $1  ;;
            *.zip)       unzip $1   ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1  ;;
            *)        echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# colorful man pages
function man {
    LESS_TERMCAP_md=$'\e[01;31m' \
        LESS_TERMCAP_me=$'\e[0m' \
        LESS_TERMCAP_se=$'\e[0m' \
        LESS_TERMCAP_so=$'\e[01;44;33m' \
        LESS_TERMCAP_ue=$'\e[0m' \
        LESS_TERMCAP_us=$'\e[01;32m' \
        command man "$@"
}

source "${HOME}/.zgen/zgen.zsh"

function s() {
    # default to "start" script
    local script="start"
    if [ -f "package.json" ]; then

        if jq -e '.scripts.dev' package.json >/dev/null; then
            script="dev"
        fi
    else
        echo "No package.json file found. Exiting..."
        exit 1
    fi
    # define binay to run (npm or yarn based on lock file)
    local bin="npm"
    if [ -f "yarn.lock" ]; then
        bin="yarn"
    else
        bin="npm"
    fi

    # run the script
    $bin run "$script" "$@"
}

# if the init script doesn't exist
if ! zgen saved; then
    echo "Creating a zgen save"

    # specify plugins here
    zgen oh-my-zsh
    zgen oh-my-zsh themes/arrow
    zgen oh-my-zsh plugins/z
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/gitfast
    zgen oh-my-zsh plugins/docker
    zgen oh-my-zsh plugins/docker-compose
    zgen oh-my-zsh plugins/npm
    zgen oh-my-zsh plugins/yarn
    # keep highlighting lean for faster startup
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-autosuggestions
    zgen load popstas/zsh-command-time

    # generate the init script from plugins above
    zgen save
fi

# vim mode
bindkey -v

# fix backspace not woriking after going to normal mode and back
bindkey "^?" backward-delete-char

# Activate virtual env and save the path as a tmux variable,
# so that new panes/windows can re-activate as necessary
function sv() {
    # source venv/bin/activate &&  # commented out by conda initialize
    tmux set-environment VIRTUAL_ENV $VIRTUAL_ENV
}

# bun completions
[ -s "/Users/abdellah/.bun/_bun" ] && source "/Users/abdellah/.bun/_bun"

# solana completions
[ -s "$HOME/.solana/_completions" ] && source "$HOME/.solana/_completions"

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Set up fzf key bindings and fuzzy completion (without spawning the fzf binary)
if [[ -o interactive ]]; then
  # Homebrew fzf scripts
  FZF_SHELL_DIR="/opt/homebrew/opt/fzf/shell"
  if [[ -f "$FZF_SHELL_DIR/key-bindings.zsh" ]]; then
    source "$FZF_SHELL_DIR/key-bindings.zsh"
  fi
  if [[ -f "$FZF_SHELL_DIR/completion.zsh" ]]; then
    source "$FZF_SHELL_DIR/completion.zsh"
  fi
fi


__nvm_lazy_source() {
  : "${NVM_DIR:=$HOME/.nvm}"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}
nvm()  { unset -f nvm; __nvm_lazy_source; command nvm "$@"; }
node() { unset -f node; __nvm_lazy_source; command node "$@"; }
npm()  { unset -f npm;  __nvm_lazy_source; command npm "$@"; }
npx()  { unset -f npx;  __nvm_lazy_source; command npx "$@"; }

# Lazy-load rbenv and friends on first use
__rbenv_lazy_init() {
  if command -v rbenv >/dev/null 2>&1; then
    # remove wrappers so subsequent calls hit real commands/shims
    unset -f rbenv ruby gem bundle rake rails irb 2>/dev/null
    eval "$(rbenv init - zsh 2>/dev/null)"
  fi
}
rbenv() { unset -f rbenv; __rbenv_lazy_init; command rbenv "$@"; }
ruby()  { unset -f ruby; __rbenv_lazy_init; command ruby  "$@"; }
gem()   { unset -f gem; __rbenv_lazy_init; command gem   "$@"; }
bundle(){ unset -f bundle; __rbenv_lazy_init; command bundle "$@"; }
rake()  { unset -f rake; __rbenv_lazy_init; command rake  "$@"; }
rails() { unset -f rails; __rbenv_lazy_init; command rails "$@"; }
irb()   { unset -f irb; __rbenv_lazy_init; command irb   "$@"; }

# uncomment to enable profiling
# zprof
