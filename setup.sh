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

ln -s $DIR/vimrc $HOMEDIR/.vimrc
ln -s $DIR/vim $HOMEDIR/.vim
ln -s $DIR/bashrc $HOMEDIR/.bashrc
ln -s $DIR/bash_profile $HOMEDIR/.bash_profile
ln -s $DIR/hgignore $HOMEDIR/.hgignore
ln -s $DIR/gitignore $HOMEDIR/.gitignore
ln -s $DIR/tmux.conf $HOMEDIR/.tmux.conf
ln -s $DIR/tmux-powerline $HOMEDIR/.tmux-powerline

# Post Installation Setup

source $HOMEDIR/.bashrc
vim +BundleClean! +BundleInstall! +qall!
