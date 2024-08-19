#! /usr/bin/bash
set -e
if [ "$EUID" -ne 0 ]
then
    echo "Global install must be ran as root!"
    exit 1
fi

if ! command -v nvim &> /dev/null
then
    echo "Neovim must be installed for this script to be ran."
    exit 1
fi

if ! command -v node &> /dev/null
then
    echo "NodeJS must be installed. It can be installed by running the following as root:"
    echo "curl -sL install-node.vercel.app/lts | bash"
    exit 1
fi

# Install font
cp -r adobe-source-code-pro/ /usr/share/fonts/

pip install pyright --quiet --exists-action i
pip install pynvim --quiet --exists-action i

SRC_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
XDG_OLD=$XDG_CONFIG_HOME
for homeidr in /home/*
do 
    pushd $homedir

    mkdir -p .config/nvim
    pushd .config/nvim

    if [ -f .config/nvim/init.vim ]
    then
        mv .config/nvim/init.vim .config/nvim/init.vim.bak"$(date +"%Y-%m-%d-%s")"
    fi

    cp $SRC_DIR/init.vim init.vim
    mkdir -p .config/nvim/autoload
    curl -o autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    export $XDG_CONFIG_HOME=$(PWD)
    nvim +PlugInstall +qall
    nvim +PlugUpdate +qall
    nvim +CocInstall coc-pyright +qall

    popd
    popd
done

export $XDG_CONFIG_HOME=$XDG_OLD
