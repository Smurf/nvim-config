#! env bash

cp /home/$USER/.config/nvim/init.vim /home/$USER/.config/nvim/init.vim.bak$(date +"%Y-%m-%d-%s")
cp ./init.vim /home/$USER/.config/nvim/init.vim

pip install pyright
pip install pynvim
vim +PlugInstall +qall
vim +PlugUpdate +qall
vim +CocInstall coc-pyright +qall
