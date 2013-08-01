#!/bin/bash

if [[ -n $(git ls-files -m) ]]
then 
    echo "You will need to add and commit the following files to"
    echo "your repository in `pwd`:"
    echo `git ls-files -m`
else
    echo "Syncing files"
    git pull -u origin master
fi
