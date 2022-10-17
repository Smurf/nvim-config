#! /usr/bin/bash
set -e
cp /home/$USER/.config/nvim/init.vim /home/$USER/.config/nvim/init.vim.bak$(date +"%Y-%m-%d-%s")
cp ./init.vim /home/$USER/.config/nvim/init.vim

pip install pyright --quiet --exists-action i
pip install pynvim --quiet --exists-action i
nvim +PlugInstall +qall
nvim +PlugUpdate +qall
nvim +CocInstall coc-pyright +qall

echo "You MUST install nodejs either from your package manager or with the following command:"
echo "curl -sL install-node.vercel.app/lts | bash"
