HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd

zstyle :compinstall filename '/home/abdellah/.zshrc'

# capitalization agnostique completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# managing dotfiles with a git bare repo
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

export GOPATH=$HOME/go
export PATH=$PATH:$HOME/.cargo/bin:/usr/local/go/bin:$GOPATH/bin:~/.scripts:~/.local/bin:~/.npm-global/bin

export NPM_CONFIG_PREFIX=~/.npm-global

export VISUAL=nvim
export EDITOR="$VISUAL"

export KEYTIMEOUT=1

alias v=nvim
alias vim=nvim
alias d="dirs -v | head"
alias v.="vifm ."
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
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-autosuggestions

    # generate the init script from plugins above
    zgen save
fi

# vim mode
bindkey -v

# fix backspace not woriking after going to normal mode and back
bindkey "^?" backward-delete-char

export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
