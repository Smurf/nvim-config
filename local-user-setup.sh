#! /usr/bin/bash
set -e

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

if [ -f /home/"$USER"/.config/nvim/init.vim ]
then
    mv /home/"$USER"/.config/nvim/init.vim /home/"$USER"/.config/nvim/init.vim.bak"$(date +"%Y-%m-%d-%s")"
fi

# Install font
cp -r adobe-source-code-pro/ /usr/share/fonts/

# Make it is not system wide
sed -i '/let g:nvim_system_wide = 0/c\let g:nvim_system_wide = 1' ./init.vim

cp ./init.vim /home/$USER/.config/nvim/init.vim

pip install pyright --quiet --exists-action i
pip install pynvim --quiet --exists-action i
nvim +PlugInstall +qall
nvim +PlugUpdate +qall
nvim +CocInstall coc-pyright +qall
