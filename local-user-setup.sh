#! /usr/bin/bash
set -e

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

if ! command -v node &> /dev/null
then
    echo "NodeJS must be installed. It can be installed by running the following as root:"
    echo "curl -sL install-node.vercel.app/lts | bash"
    exit 1
fi

if ! command -v yarn &> /dev/null
then
    echo "yarn must be installed for this script to be ran."
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

if [ ! -d "$USER_DIR"/.local/share/nvim/site/pack/packer/start/packer.nvim ]
then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$USER_DIR"/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

pip install pyright --quiet --exists-action i
pip install pynvim --quiet --exists-action i
nvim +PackerInstall +qall
nvim +PackerSync +qall
nvim +CocInstall coc-pyright +qall
nvim +CocInstall '@yaegassy/coc-ansible' +qall
nvim +CocCommand 'ansible.builtin.installRequirementsTools' +qall
nvim +CocInstall coc-go +qall
