# uncomment to enable profiling
# zmodload zsh/zprof

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd

zstyle :compinstall filename '/home/abdellah/.zshrc'

# capitalization agnostique completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

export GOPATH=$HOME/go
export PATH=$PATH:$HOME/.cargo/bin:/usr/local/go/bin:$GOPATH/bin:~/.scripts:~/.local/bin

export VISUAL=nvim
export EDITOR="$VISUAL"

export KEYTIMEOUT=1

alias v=nvim
alias vim=nvim
alias mv='mv -i'
alias yt=youtube-dl

function zz {
    zathura $@ > /dev/null 2>&1 &|
}

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
    zgen oh-my-zsh plugins/docker
    zgen oh-my-zsh plugins/fzf
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-autosuggestions

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
    source venv/bin/activate &&
    tmux set-environment VIRTUAL_ENV $VIRTUAL_ENV
}
if [ -n "$VIRTUAL_ENV" ]; then
    source $VIRTUAL_ENV/bin/activate;
fi

export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export PATH="/opt/homebrew/opt/postgresql@12/bin:$PATH"

# bun completions
[ -s "/Users/abdellah/.bun/_bun" ] && source "/Users/abdellah/.bun/_bun"

# bun
export BUN_INSTALL="/Users/abdellah/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# uncomment to enable profiling
# zprof
