#!/bin/bash

CWD=`pwd`
BAK=$HOME/.dotfiles-backup/

mkdir -p $BAK

mv $HOME/.vimrc $BAK
ln -s $CWD/config/vimrc $HOME/.vimrc
