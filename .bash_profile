# Source Bash Prompt
[[ -f "$HOME/.bash_prompt" ]] && source "$HOME/.bash_prompt"

# rbenv initialize
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
