#!/bin/bash

cd $( dirname `readlink ~/.bashrc` )
if [[ -n $(git ls-files -m) ]]
then
    echo "You will need to add and commit the following files to"
    echo "your repository in `pwd`:"
    echo `git ls-files -m`
else
    echo "Checking for updates..."
    git fetch origin
    if [[ -n $(git log HEAD..origin/master --oneline) ]]
    then
        git pull -u origin master -q
        . ./setup.sh
    else
        echo "Up to date!"
    fi
fi
cd - > /dev/null
