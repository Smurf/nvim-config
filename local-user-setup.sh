#! /usr/bin/bash
set -e

if ! command -v npm &> /dev/null
then
    echo "Install NPM!"
    exit 1
fi

if [ "$1x" == "x" ]
then
    USER_DIR="/home/$USER"
else
    USER_DIR="/home/$1"
fi

if ! command -v nvim &> /dev/null
then
    echo "Neovim must be installed for this script to be ran."
    exit 1
fi

if [ -d "$USER_DIR/.config/nvim" ]
then
    mv "$USER_DIR/.config/nvim" "$USER_DIR/.config/nvim.bak$(date +"%Y-%m-%d-%s")"
fi

cp -r nvim "$USER_DIR/.config/"
#Move into home config dir
pushd "$USER_DIR/.config/nvim"

# Install hack font
curl -L -o /tmp/hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip
unzip -o /tmp/hack.zip -d "$USER_DIR/.local/share/fonts/"
rm -f /tmp/hack.zip
fc-cache -fv

if [ ! -d "$USER_DIR"/.local/share/nvim/site/pack/packer/start/packer.nvim ]
then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$USER_DIR"/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

npm install -g yaml-language-server
pip install basedpyright --quiet --exists-action i
pip install pynvim --quiet --exists-action i
nvim +PackerSync +qall
