{ config, pkgs, lib, ... }:

let
  fromFile = file: "\n${builtins.readFile file}\n";
  demophoon_theme = fromFile ./themes/demophoon.zsh-theme;
in {
  home.file."${config.home.homeDirectory}/.oh-my-zsh/custom/themes/demophoon.zsh-theme".text = demophoon_theme;

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    history = {
      extended = true;
    };
    oh-my-zsh = {
      enable = true;
      theme = "demophoon";
      custom = "${config.home.homeDirectory}/.oh-my-zsh/custom";
      plugins = [
        "git"
        "github"
        "python"
        "golang"
        "vagrant"
      ];
      extraConfig = ''
      source $HOME/.nix-profile/etc/profile.d/nix.sh
      ${ fromFile ./scripts/aliases.sh }
      ${ fromFile ./scripts/dockerfunc.sh }

      # Local configs
      [ -f ~/.localrc ] && source ~/.localrc
      export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib"
      '';
    };
  };

  home.shellAliases = {
    # Common Aliases
    ls = "ls";
    l = "ls -lhG";
    ll = "ls -AlhG";
    v = "nvim";
    vi = "nvim";
    vim = "nvim";
    cdc = "cd ~/projects/";
    tp = "attach";
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

    # Zoxide (Better cd)
    cd = "z";
  };

}
