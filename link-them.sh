#!/bin/bash

CWD=`pwd`

DOT_CONFIGS=`find dot-config -type f | sed  "s/dot-config\///"`
DOT_CONFIG_DIRS=`find dot-config -type d`
CONFIGS=`ls -F config | grep '[a-zA-Z0-9]$'`
BINS=`ls -F bin | grep '\*$' | sed 's/\*$//'`

BAK=$HOME/.dotfiles-backup
for i in $DOT_CONFIG_DIRS;
do
  mkdir -p "$BAK/$i"
done

for i in $DOT_CONFIGS;
do
    if [ -f "$HOME/.config/$i" ]; then cp $HOME/.config/$i $BAK/dot-config/$i; fi
    rm $HOME/.config/$i
    ln -s $CWD/dot-config/$i $HOME/.config/$i
done

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

if [ ! -f "$HOME/.gitconfig-local" ]
then
    echo "Put your machine/user specific git config here" > "$HOME/.gitconfig-local"
fi
