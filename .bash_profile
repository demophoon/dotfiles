# Source Bash Prompt
[[ -f "$HOME/.bash_prompt" ]] && source "$HOME/.bash_prompt"

# Source Bashrc if file exists
[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

# rbenv initialize
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
