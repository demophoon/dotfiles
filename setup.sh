#!/bin/bash

# Paranoid mode. Exit on error.
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOMEDIR=${HOME:?}
merge_directories=(.config)
ignoredfiles=(.git .gitmodules LICENSE.md README.md push.sh setup.sh update.sh install.sh install.py utils .DS_Store Brewfile assets files Filefile)

# If we force links to directories which we are deep merging, we gonna have a bad time...
ignoredfiles+=(${merge_directories[@]})

createLinks() {
    for f in ${DIR:?}/{*,.*}; do
        filename=$(basename "$f")
        if [[ ${ignoredfiles[*]} =~ $filename ]]; then
            continue
        fi
        rm -rf "${HOMEDIR:?}/${filename:?}" > /dev/null
        ln -s "${DIR:?}/${filename:?}" "${HOMEDIR:?}/${filename:?}"
    done
}

updateVimPlugins() {
    echo "Updating Vim Plugins..."
    vim -i NONE -c BundleInstall -c BundleClean -c qall!
}

realizeDirectories() {
    filepath=${1:?}
    realize_path="${HOMEDIR:?}/${filepath%/*}"
    if [ ! -d "${realize_path:?}" ]; then
        mkdir -p "${realize_path:?}"
    fi
}

deepMergeDir() {
    mergePath=${1:?}
    if [ ! -d ${mergePath:?} ]; then
        if [ -e ${mergePath:?} ]; then
            dotfiles_file=${mergePath#$DIR/}
            realizeDirectories ${dotfiles_file}
            rm -f "${HOMEDIR:?}/${dotfiles_file:?}"
            ln -s "${DIR:?}/${dotfiles_file:?}" "${HOMEDIR:?}/${dotfiles_file:?}"
        fi
    else
        for dir in $(find ${mergePath:?}/* -maxdepth 0); do
            deepMergeDir "${dir:?}"
        done
    fi
}

mergeDirs() {
    for dir in ${merge_directories:?}; do
        deepMergeDir "${DIR:?}/${dir:?}"
    done
}

linkDotfiles() {
    createLinks
    mergeDirs
}

if [ "$1" = '-f' -o "$1" = '--force' ]; then
    linkDotfiles
else
    read -n 1 -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " reply
    echo

    reply=$(echo "$reply" | tr '[:upper:]' '[:lower:]')

    if [ "${reply}" = 'y' ]; then
        linkDotfiles
    fi
fi
