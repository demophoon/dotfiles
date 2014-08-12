# Source Bashrc if file exists
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

# rbenv stuff
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
