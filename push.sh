#!/bin/bash

cd $( dirname `readlink ~/.bashrc` )
git push -u origin master
source ~/.bashrc
cd --
