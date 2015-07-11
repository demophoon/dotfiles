#!/bin/bash

# Paranoid mode. Exit on error.
set -e

required=(git python vim tmux zsh)
optional=(python-pip python-virtualenv python-dev irssi mercurial tree git-annex)
graphical=(chromium vlc virtualbox deluge vagrant guake)
graphical_requires=(keepass2)

export required
export optional
export graphical
export graphical_requires

updated_package_list='n'

function update_package_list() {
    if [ "$updated_package_list" = 'n' ]; then
        echo "Updating sources list..."
        sudo apt-get update > /dev/null
        updated_package_list='y'
    fi
}

function downloadList() {
    varname=${1:?}
    update_package_list
    packages=${!varname}
    for package in ${packages}; do
        downloadPackage "${package}"
    done
}

function printList() {
    varname=${1:?}
    list=${!varname}
    for item in ${list}; do
        echo " - ${item}"
    done
}

function downloadPackage() {
    package=${1:?}
    update_package_list
    echo "Installing ${package}..."
    sudo apt-get install "${package}" -y > /dev/null
}

function downloadDotfiles() {
    if [ ! -d ~/dotfiles ]; then
        git clone https://github.com/demophoon/dotfiles ~/dotfiles
    fi
    cd ~/dotfiles
    git submodule update --init
    source ~/dotfiles/setup.sh
    echo "Dotfile installation complete"
}

function wizard() {
    title=${1:?}
    name=${2:?}
    afterRequires=$3
    after=$4

    echo "${title} Packages: "
    printList "${name}"
    printList "${afterRequires}"
    read -n 1 -p "Install the packages above for Britt Gresham's dotfiles? (Y/N) " reply
    echo

    reply=$(echo "$reply" | tr '[:upper:]' '[:lower:]')

    if [ "${reply}" = 'y' ]; then
        downloadList "${name}"
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
    unamestr=$(uname)
    if [ "${unamestr}" = 'Linux' ]; then
        wizard "Required" required
        wizard "Optional" optional
        wizard "Grapical" graphical graphical_requires installExtraGraphicalTools
    fi
    downloadDotfiles
    echo "Done!"
}

runPrompts
