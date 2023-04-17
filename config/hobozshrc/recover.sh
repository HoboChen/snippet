#!/bin/sh

cp hobozshrc ~/.zshrc
cp hobotmuxconf ~/.tmux.conf
cp hobotmuxconflocal ~/.tmux.conf.local 

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# C-a I
