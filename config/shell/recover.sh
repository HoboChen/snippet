#!/bin/sh

cp hobozshrc ~/.zshrc
cp hobotmuxconf ~/.tmux.conf
cp hobotmuxconflocal ~/.tmux.conf.local 

rm -r ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# C-a I