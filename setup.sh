#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOMEDIR=${HOME}
ignoredfiles=(.git .gitmodules LICENSE.md README.md push.sh setup.sh update.sh install.sh install.py utils .DS_Store Brewfile assets)

function createLinks() {
    for f in `ls -A $DIR`; do
        filename=$(basename $f)
        if [[ ${ignoredfiles[*]} =~ "$filename" ]]; then
            continue
        fi
        rm -f "$HOMEDIR/$filename" > /dev/null
        ln -s $DIR/$filename $HOMEDIR/$filename
    done
}

if [[ $1 =~ ^(-f|--force)$ ]]; then
    createLinks
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        createLinks
    fi
fi
unset createLinks
