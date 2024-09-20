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

if ! command -v yarn &> /dev/null
then
    echo "yarn must be installed for this script to be ran."
    exit 1
fi


# Make it is not system wide
sed -i '/let g:nvim_system_wide = 1/c\let g:nvim_system_wide = 0' ./init.vim

#Note current dir and make local config dir
GIT_DIR="$PWD"
mkdir -p /home/"$USER"/.config/nvim

#Move into home config dir
pushd /home/"$USER"/.config/nvim
echo $PWD
if [ -f init.vim ]
then
    mv init.vim init.vim.bak"$(date +"%Y-%m-%d-%s")"
fi

# Install font
cp -r $GIT_DIR/adobe-source-code-pro/* /home/"$USER"/.local/share/fonts/

cp $GIT_DIR/init.vim init.vim
mkdir -p /home/"$USER"/.config/nvim/autoload
curl -o autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

pip install pyright --quiet --exists-action i
pip install pynvim --quiet --exists-action i
pip install jedi --quiet --exists-action i
nvim +PlugInstall +qall
nvim +PlugUpdate +qall
nvim +CocInstall coc-pyright +qall
nvim +CocInstall '@yaegassy/coc-ansible' +qall
nvim +CocCommand 'ansible.builtin.installRequirementsTools' +qall
