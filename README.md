Installation
============
Run this command in your Debian based terminal:

    wget -N https://raw.github.com/demophoon/dotfiles/master/install.sh && source install.sh

On Mac:
    You will want to install Homebrew (http://brew.sh/) and run `brew bundle Brewfile` before you run the command above.
    Run the following command on in a mac terminal to apply osx settings.

    source ./.osx
    sudo reboot

Or pull down the repository and run `setup.sh` to let the magic happen.

### Warning

THIS WILL REMOVE YOUR CURRENT DOTFILES IN YOUR HOME DIRECTORY.
MAKE BACKUPS BEFORE INSTALLING

To automatically enable pushing to origin after commit run these commands

    chmod a+x ./push.sh
    ln -s ./push.sh ./.git/hooks/post-commit

### Install Script

* `setup.sh [--force]`
    - Installs dotfiles into home directory.
      Warning: This will remove current settings in your home directory! Only
      run if you want the dotfiles in this repository! You have been warned!

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

