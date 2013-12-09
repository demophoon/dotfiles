Installation
------------
To install dotfiles run setup.sh and let the magic happen

*Warning*
THIS WILL REMOVE YOUR CURRENT DOTFILES IN YOUR HOME DIRECTORY.
MAKE BACKUPS BEFORE INSTALLING

To automatically enable pushing to origin after commit run these commands
chmod a+x ./push.sh
ln -s ./push.sh ./.git/hooks/post-commit
