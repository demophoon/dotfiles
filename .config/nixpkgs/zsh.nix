{ config, pkgs, ... }:

let
  dotfiles_repo = builtins.fetchGit {
    url = "https://github.com/demophoon/dotfiles.git";
    ref = "nix";
    rev = "173eee81c3da14806033dd37798bde6631b9835c";
  };
  zsh-custom = "${dotfiles_repo.outPath}/.oh-my-zsh/custom";
in {
  programs.zsh = {
    enable = true;
    shellAliases = {
      # Common Aliases
      tmux = "TERM = screen-256color-bce tmux";
      ls = "ls";
      l = "ls -lhG";
      ll = "ls -AlhG";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      cdc = "cd ~/projects/";
      tp = "attach";
      update_dotfiles = ". $(dirname `readlink ~/.bashrc`)/update.sh";
      pupper = "puppet";
      irc = "attach irc -d";
      notepad = "vim ~/.notes.md";
      run_puppet = "sudo /etc/puppetlabs/code/environments/production/install.sh run";

      # Git Aliases
      gs = "git status";
      ga = "git add --ignore-removal";
      gc = "git commit -v";
      gp = "git push";
      gl = "git log --pretty=format:'%C(dim cyan)%G?%C(reset) %C(yellow)%h%C(reset) - %C(green)(%cr)%C(reset) %C(bold white)%an%C(reset) %s %C(bold blue)%d%C(reset)' --graph --date-order --date=relative --abbrev-commit";
      gd = "git diff";
      gf = "git fetch";

      vvim = "vim -u NONE";
      vanillavim = "vim -u NONE";
    };

    oh-my-zsh = {
      enable = true;
      custom = zsh-custom;
      theme = "demophoon";
      plugins = [
        "git"
        "github"
        "zsh-syntax-highlighting"
        "python"
        "golang"
        "zsh-autosuggestions"
        "vagrant"
      ];
    };
  };
}
