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

if [ -f /home/"$USER"/.config/nvim/init.vim ]
then
    mv /home/"$USER"/.config/nvim/init.vim /home/"$USER"/.config/nvim/init.vim.bak"$(date +"%Y-%m-%d-%s")"
fi

# Make it system wide
sed -i '/let g:nvim_system_wide = 0/c\let g:nvim_system_wide = 1' ./init.vim

mkdir -p /etc/xdg/nvim
mkdir -p /usr/local/share/nvim/site
curl -fLo /etc/xdg/nvim/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp ./init.vim /etc/xdg/nvim/sysinit.vim

pip install pyright --quiet --exists-action i
pip install pynvim --quiet --exists-action i
nvim +PlugInstall +qall
nvim +PlugUpdate +qall
nvim +CocInstall coc-pyright +qall
