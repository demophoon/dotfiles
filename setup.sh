#!/bin/bash

# Paranoid mode. Exit on error.
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOMEDIR=${HOME:?}
ignoredfiles=(.git .gitmodules LICENSE.md README.md push.sh setup.sh update.sh install.sh install.py utils .DS_Store Brewfile.sh assets files)

function createLinks() {
    for f in ${DIR:?}/{*,.*}; do
        filename=$(basename "$f")
        if [[ ${ignoredfiles[*]} =~ $filename ]]; then
            continue
        fi
        rm -rf "${HOMEDIR:?}/${filename:?}" > /dev/null
        ln -s "${DIR:?}/${filename:?}" "${HOMEDIR:?}/${filename:?}"
    done
}

function updateVimPlugins() {
    echo "Updating Vim Plugins..."
    vim -i NONE -c BundleInstall -c BundleClean -c qall!
}

if [ "$1" = '-f' -o "$1" = '--force' ]; then
    createLinks
else
    read -n 1 -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " reply
    echo

    reply=$(echo "$reply" | tr '[:upper:]' '[:lower:]')

    if [ "${reply}" = 'y' ]; then
        createLinks
        updateVimPlugins
    fi
fi
unset createLinks
