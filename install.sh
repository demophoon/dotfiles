#!/bin/bash

required=(git python vim tmux)

optional=(python-pip python-virtualenv python-dev irssi)

function downloadList() {
    for f in $1
    do
        downloadPackage $f
    done
}

function downloadPackage() {
    package=$1
    sudo apt-get install $package
}

function downloadDotfiles() {
    git clone https://github.com/demophoon/dotfiles
    cd ./dotfiles
    . ./setup.sh
    echo "Dotfile installation complete"
}

echo "Required Packages: "
for f in ${required[@]}
do
    echo " - $f"
done
read -p "Would you like to download all required packages for Britt Gresham's dotfiles? (Y/N) " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    downloadList required
fi

echo "Optional Packages: "
for f in ${optional[@]}
do
    echo " - $f"
done
read -p "Would you like to download all optional packages for Britt Gresham's dotfiles? (Y/N) " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    downloadList optional
fi

read -p "Would you like to download Britt Gresham's Dotfiles from 'https://github.com/demophoon/dotfiles'? (Y/N) " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    downloadDotfiles
fi
