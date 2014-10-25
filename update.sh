#!/bin/bash

dotfiles_repo=$( dirname `readlink ~/.bashrc` )

cd $dotfiles_repo
local_branch_name=`git name-rev --name-only HEAD`
tracking_branch_name=$(git for-each-ref --format='%(upstream)' $(git symbolic-ref -q HEAD))
tracking_branch_remote=`git config branch.$local_branch_name.remote`

if [[ -n $(git diff --name-only) || -n $(git diff --name-only --cached) ]]; then
    echo "You will need to stage and commit the following files to your repository in"
    echo "$dotfiles_repo"
    echo "-------------------------------------------------------------------------------"
    if [[ -n $(git diff --name-only) ]]; then
        echo "Stage:"
        echo "`git diff --name-status`"
    fi
    if [[ -n $(git diff --name-only --cached) ]]; then
        echo "Commit:"
        echo "`git diff --name-status --cached`"
    fi
else
    echo "Checking for updates..."
    git fetch $tracking_branch_remote
    if [[ -n $(git log HEAD..$tracking_branch_remote --oneline) ]]
    then
        git merge $tracking_branch_name -q
        . ./setup.sh -f
    else
        echo "Up to date!"
    fi
fi
cd - > /dev/null
