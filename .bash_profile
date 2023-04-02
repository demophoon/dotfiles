# Source Bash Prompt
[[ -f "$HOME/.bash_prompt" ]] && source "$HOME/.bash_prompt"

# rbenv initialize
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

if [ -e /home/britt/.nix-profile/etc/profile.d/nix.sh ]; then . /home/britt/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
