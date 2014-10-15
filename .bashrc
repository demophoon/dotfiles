[ -z "$PS1" ] && return

set -o vi
bind -m vi-insert "\C-l":clear-screen

bind TAB:menu-complete
export EDITOR="vim"
export PYTHONSTARTUP="$(dirname `readlink ~/.bashrc`)/.pythonrc"

if [ -e "/usr/local/bin/virtualenvwrapper.sh" ]; then
    export WORKON_HOME=$HOME/.virtualenvs/
    export PROJECT_HOME=$HOME/Devel/
    source /usr/local/bin/virtualenvwrapper.sh
fi

dotfiles=$( dirname `readlink ~/.bashrc` )
dotfilesupdate=". $dotfiles/update.sh"


if [ -d "$HOME/.rbenv/bin" ]; then
    PATH=$HOME/.rbenv/bin:$PATH
fi
$dotfilesupdate
export DISPLAY=:0

# Git fetch pull requests from upstream

fetchpr () {
  pr_num=$1
  git fetch puppetlabs "refs/pull/${pr_num}/head"
  git checkout -b "pull-${pr_num}" FETCH_HEAD
}

# Git autocomplete
source ~/.git-completion.sh

source $HOME/.commonrc

if [ -e "$HOME/.bashrc.local" ]; then
    source $HOME/.bashrc.local
fi

# Common things
[[ -s "$HOME/.commonrc" ]] && source "$HOME/.commonrc"
