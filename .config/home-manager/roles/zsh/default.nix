{ config, pkgs, ... }:

let
  dotfiles_repo = import ./dotfiles.nix;
  zsh-custom = "${dotfiles_repo.outPath}/.oh-my-zsh/custom";

  fromFile = file: "\n${builtins.readFile file}\n";
in {
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    history = {
      extended = true;
    };
    oh-my-zsh = {
      enable = true;
      custom = zsh-custom;
      theme = "demophoon";
      plugins = [
        "git"
        "github"
        "python"
        "golang"
        "vagrant"
      ];
      extraConfig = ''
      source $HOME/.nix-profile/etc/profile.d/nix.sh
      ${ fromFile ./aliases.sh }
      ${ fromFile ./dockerfunc.sh }

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
