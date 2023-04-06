#!/usr/bin/sh

rm -rf $HOME/.vim
mkdir -p $HOME/.vim

cp hobovimrc $HOME/.vimrc
cp hoboycmconf $HOME/.ycm_extra_conf.py

mkdir $HOME/.vim/bundle && cd $HOME/.vim/bundle && git clone https://github.com/gmarik/vundle

# echo "pushd ./install.py --clang-completer"
