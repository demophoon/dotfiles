#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Delete Existing Dotfiles

rm -rf ~/.vim
rm -f ~/.vimrc
rm -f ~/.bashrc
rm -f ~/.bash_profile
rm -f ~/.hgignore
rm -f ~/.gitignore

# Create Symlinks

ln -s $DIR/vimrc ~/.vimrc
ln -s $DIR/vim ~/.vim
ln -s $DIR/bashrc ~/.bashrc
ln -s $DIR/bash_profile ~/.bash_profile
ln -s $DIR/hgignore ~/.hgignore
ln -s $DIR/gitignore ~/.gitignore

# Install Bundles using Vundle

vim +BundleClean +BundleInstall +qall
