#!/bin/sh

cp hobozshrc ~/.zshrc
cp hobotmuxconf ~/.tmux.conf
cp hobotmuxconflocal ~/.tmux.conf.local 
cp af-magic.zsh-theme /home/hobochen/.oh-my-zsh/themes/af-magic.zsh-theme

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# C-a I
