#!/bin/bash

cd $( dirname `readlink ~/.bashrc` )
branch_name=$(git symbolic-ref -q HEAD)
if [[ -n $(git ls-files -m) ]]
then
    echo "You will need to add and commit the following files to"
    echo "your repository in `pwd`:"
    echo `git ls-files -m`
else
    echo "Checking for updates..."
    git fetch origin
    if [[ -n $(git log HEAD..origin/$branch_name --oneline) ]]
    then
        git pull -u origin $branch_name -q
        . ./setup.sh
    else
        echo "Up to date!"
    fi
fi
cd - > /dev/null
