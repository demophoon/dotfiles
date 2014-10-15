[ -z "$PS1" ] && return

set -o vi
bind -m vi-insert "\C-l":clear-screen

bind TAB:menu-complete
export PYTHONSTARTUP="$(dirname `readlink ~/.bashrc`)/.pythonrc"

export DISPLAY=:0

# Git autocomplete
source ~/.git-completion.sh

source $HOME/.commonrc

if [ -e "$HOME/.bashrc.local" ]; then
    source $HOME/.bashrc.local
fi

# Common things
[[ -s "$HOME/.commonrc" ]] && source "$HOME/.commonrc"
