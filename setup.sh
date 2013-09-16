#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Delete Existing Dotfiles

rm -rf ~/.vim
rm -f ~/.vimrc
rm -f ~/.bashrc
rm -f ~/.bash_profile
rm -f ~/.hgignore
rm -f ~/.gitignore
rm -f ~/.tmux.conf
rm -rf ~/.tmux-powerline

# Create Symlinks

ln -s $DIR/vimrc ~/.vimrc
ln -s $DIR/vim ~/.vim
ln -s $DIR/bashrc ~/.bashrc
ln -s $DIR/bash_profile ~/.bash_profile
ln -s $DIR/hgignore ~/.hgignore
ln -s $DIR/gitignore ~/.gitignore
ln -s $DIR/tmux.conf ~/.tmux.conf
ln -s $DIR/tmux-powerline ~/.tmux-powerline

# Install Bundles using Vundle

vim +BundleClean! +BundleInstall! +qall!
