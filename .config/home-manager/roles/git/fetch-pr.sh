#!/bin/bash

REMOTE=$1

if [ $(git remote | grep "${REMOTE?}") ]; then
    if [[ ! -n $(git config --local --get-all remote.${REMOTE?}.fetch | grep refs/remotes/${REMOTE?}/pr/) ]]; then
        echo "Adding remote pr ref"
        git config --local --add "remote.${REMOTE?}.fetch" "+refs/pull/*/head:refs/remotes/${REMOTE?}/pr/*"
    fi
    echo "Fetching remote pr refs"
    git fetch "${REMOTE?}"
else
    echo "Remote does not exist. Please add the '${REMOTE?}' remote and run the command again."
fi
