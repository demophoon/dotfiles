#!/bin/bash

# Paranoid mode. Exit on error.
set -e

common_rc_path=$(readlink ~/.bashrc)
dotfiles_repo=$(dirname "${common_rc_path:?}")

pushd "${dotfiles_repo:?}" > /dev/null
local_branch_name=$(git name-rev --name-only HEAD)
tracking_branch_name=$(git for-each-ref --format='%(upstream)' "$(git symbolic-ref -q HEAD)")
tracking_branch_remote=$(git config branch."${local_branch_name}".remote)

if [ -n "$(git diff --name-only)" ] || [ -n "$(git diff --name-only --cached)" ]; then
    echo "You will need to stage and commit the following files to your repository in $dotfiles_repo"
    if [ -n "$(git diff --name-only)" ]; then
        echo "Stage:"
        git --no-pager diff --name-status
    fi
    if [ -n "$(git diff --name-only --cached)" ]; then
        echo "Commit:"
        git --no-pager diff --name-status --cached
    fi
else
    echo "Checking for updates..."
    git fetch "${tracking_branch_remote:?}"
    if [ -n "$(git log HEAD.."${tracking_branch_remote:?}" --oneline)" ]; then
        git merge "${tracking_branch_name:?}" -q
        git submodule update
        ./install.sh
    else
        echo "Up to date!"
    fi
fi
popd > /dev/null
