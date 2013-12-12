Installation
============
To install dotfiles run `setup.sh` and let the magic happen

### Warning

THIS WILL REMOVE YOUR CURRENT DOTFILES IN YOUR HOME DIRECTORY.
MAKE BACKUPS BEFORE INSTALLING

To automatically enable pushing to origin after commit run these commands

    chmod a+x ./push.sh
    ln -s ./push.sh ./.git/hooks/post-commit

### Install Script

If you want to install to something other than ~/ than specify a path then
running the install script (`setup.sh /some/other/path`).

### Builtin Utilities

* `tmuxproject`
    - Starts a new tmux project

* `sandbox`
    - Connects to a sandbox tmux session

* `update_dotfiles`
    - Updates dotfiles if an update exists

* `activate`
    - Finds and activates a python virtual environment if one is found in one
      of the child directories in the working directory

