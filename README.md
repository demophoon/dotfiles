Britt Gresham's Dotfiles Repo
=============================

Even though these are some pretty kick-ass configs, use at your own risk!

Installation
------------
Pull down this git repository and run `setup.sh` to install dotfiles.

    git clone https://github.com/demophoon/dotfiles ~/.dotfiles
    cd ~/.dotfiles
    ./setup.sh

These dotfiles can also be installed via
(https://github.com/demophoon/dotfiles-puppet)[Puppet].

Use zsh instead of bash!
------------------------
Even though most of these configurations are backwards compatible with bash to
get the best experience I recommend using zsh instead.

    chsh -s /bin/zsh

Install Script
--------------

* `setup.sh [--force]`
    - Installs dotfiles into home directory.
      Warning: This will remove current settings in your home directory! Only
      run if you want the dotfiles in this repository! You have been warned!

Builtin Utilities
-----------------
See `utils` for complete list.

* `attach`
    - Attach or create a tmux session automatically.
* `fetch_pr`
    - Fetches all PR references from github given a remote name.
* `firetower`
    - Automatically rerun commands when events are sent to firetower
    - Taken from https://github.com/mweitzel/firetower/.
* `google-chrome-hdpi`
    - Starts Google chrome in High DPI mode with proper scaling. Useful for 4k
      displays in Linux.
* `google_fi`
    - Enable and Disable wwan network card.
* `lein`
    - Copy of Leiningen for Clojure development.
* `livelog`
    - Monitors git log in a pretty way.
* `lock`
    - Locks linux desktop with i3lock.
* `matrix`
    - Animation from The Matrix.
    - Ultimate hacker mode.
* `pairing`
    - Automatically configure local pairing session. This command also utilizes
      `attach`.
* `sandbox`
    - Connects to a sandbox tmux session.
    - Basically is `attach sandbox` while also remapping some keys to allow
      tmux within tmux.
* `usbname`
    - Helpful tool for debugging what usb devices are plugged into a linux
      desktop.
* `vagrant-wrapper`
    - Wraps the vagrant tool to add some 'useful' features.
* `yay`
    - Help keep track of successes to ward off against imposter syndrome.

Notable Builtin Aliases
-----------------------
See `.aliases` for complete list.

* `cdc`
    - Alias to `cd ~/projects/`.
* `evim` or `easyvim`
    - Runs Vim with some beginner friendly configurations.
* `irc`
    - Alias to `attach irc -d`.
* `notepad`
    - Opens `~/.notes.md` for fast note taking.
* `run_puppet`
    - If installed with (https://github.com/demophoon/dotfiles-puppet)[Puppet]
      this alias will refetch Puppet modules and rerun puppet.
* `s3cmde`
    - Uses `gpg` to decrypt `~/.s3cfg.encrypted` and then performs `s3cmd` with
      decrypted configuration. Automatically removes decrypted config after
      running.
    - Will also run `s3cmd` if no encrypted configurations exist.
* `update_dotfiles`
    - Updates dotfiles if an update exists.
