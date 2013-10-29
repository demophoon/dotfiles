#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z $1 ]; then
    HOMEDIR="~"
else
    HOMEDIR=${1%/}
fi

# Delete Existing Dotfiles

rm -rf $HOMEDIR/.vim
rm -f $HOMEDIR/.vimrc
rm -f $HOMEDIR/.bashrc
rm -f $HOMEDIR/.bash_profile
rm -f $HOMEDIR/.hgignore
rm -f $HOMEDIR/.gitignore
rm -f $HOMEDIR/.tmux.conf
rm -rf $HOMEDIR/.tmux-powerline

# Create Symlinks

ln -s $DIR/vimrc $HOMEDIR/.vimrc > /dev/null
ln -s $DIR/vim $HOMEDIR/.vim > /dev/null
ln -s $DIR/bashrc $HOMEDIR/.bashrc > /dev/null
ln -s $DIR/bash_profile $HOMEDIR/.bash_profile > /dev/null
ln -s $DIR/hgignore $HOMEDIR/.hgignore > /dev/null
ln -s $DIR/gitignore $HOMEDIR/.gitignore > /dev/null
ln -s $DIR/tmux.conf $HOMEDIR/.tmux.conf > /dev/null
ln -s $DIR/tmux-powerline $HOMEDIR/.tmux-powerline > /dev/null

# Post Installation Setup

source $HOMEDIR/.bashrc > /dev/null
vim +BundleClean! +BundleInstall! +qall!
