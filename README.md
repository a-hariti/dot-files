# Dot files

make sure you have `stow` installed then, run `./setup.sh` to link files to their appropriate location.

## Install vim-plug

```sh
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

## Install zgen

```sh
git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
```

