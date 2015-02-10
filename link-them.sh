#!/bin/bash

CWD=`pwd`

CONFIGS=`ls -F config | grep '[a-zA-Z0-9]$'`
BINS=`ls -F bin | grep '\*$' | sed 's/\*$//'`

BAK=$HOME/.dotfiles-backup
mkdir -p $BAK

for i in $CONFIGS;
do
    if [ -f "$HOME/.$i" ]; then cp $HOME/.$i $BAK/$i.bak; fi
    rm $HOME/.$i
    ln -s $CWD/config/$i $HOME/.$i
done

BAK=$HOME/.dotfiles-backup/bin
mkdir -p $BAK

for i in $BINS;
do
    if [ -f "$HOME/bin/.$i" ]; then cp $HOME/bin/$i $BAK/$i.bak; fi
    rm $HOME/bin/$i
    ln -s $CWD/bin/$i $HOME/bin/$i
done

