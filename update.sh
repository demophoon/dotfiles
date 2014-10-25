#!/bin/bash

cd $( dirname `readlink ~/.bashrc` )
local_branch_name=`git name-rev --name-only HEAD`
tracking_branch_name=$(git for-each-ref --format='%(upstream)' $(git symbolic-ref -q HEAD))
tracking_branch_remote=`git config branch.$local_branch_name.remote`

if [[ -n $(git ls-files -m) ]]
then
    echo "You will need to add and commit the following files to"
    echo "your repository in `pwd`:"
    echo `git ls-files -m`
else
    echo "Checking for updates..."
    git fetch $tracking_branch_remote
    if [[ -n $(git log HEAD..$tracking_branch_remote --oneline) ]]
    then
        git merge $tracking_branch_name -q
        . ./setup.sh
    else
        echo "Up to date!"
    fi
fi
cd - > /dev/null
