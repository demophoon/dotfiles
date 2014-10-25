#!/bin/bash

required=(git python vim tmux zsh)
optional=(python-pip python-virtualenv python-dev irssi mercurial tree git-annex)
graphical=(chromium vlc virtualbox deluge vagrant guake)
graphicalrequires=(keepass2)

updated_package_list=0

function update_package_list() {
    if [[ "$updated_package_list" == 0 ]]
    then
        echo "Updating sources list..."
        sudo apt-get update > /dev/null
        updated_package_list=1
    fi
}

function downloadList() {
    varname=$1[@]
    update_package_list
    list=${!varname}
    for f in $list
    do
        downloadPackage $f
    done
}

function printList() {
    varname=$1[@]
    list=${!varname}
    for f in $list
    do
        echo " - $f"
    done
}

function downloadPackage() {
    package=$1
    update_package_list
    echo "Installing $package..."
    sudo apt-get install $package -y > /dev/null
}

function downloadDotfiles() {
    git clone https://github.com/demophoon/dotfiles ~/dotfiles
    cd ~/dotfiles
    git submodule update --init
    source ~/dotfiles/setup.sh
    echo "Dotfile installation complete"
}

function wizard() {
    title=$1
    name=$2
    afterRequires=$3
    after=$4

    echo "$1 Packages: "
    printList $2
    printList $afterRequires
    read -p "Install the packages above for Britt Gresham's dotfiles? (Y/N) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        downloadList $2
        $after
    fi
}

function installExtraGraphicalTools() {
    echo "Installing Keepass..."
    sudo apt-add-repository ppa:jtaylor/keepass -y > /dev/null
    sudo apt-get update -y > /dev/null
    sudo apt-get install keepass2 -y > /dev/null
}

function runPrompts() {
    unamestr=`uname`
    if [[ "$unamestr" == 'Linux' ]]
    then
        wizard "Required" required
        wizard "Optional" optional
        wizard "Grapical" graphical graphicalrequires installExtraGraphicalTools
    fi
    downloadDotfiles
    echo "Done!"
}
runPrompts
