{ config, pkgs, ... }:

let
  dotfiles_repo = import ./dotfiles.nix;
  utils = "${dotfiles_repo.outPath}/utils";
in {
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./nvim.nix
    ./zsh.nix
    ./git.nix
    ./configuration.nix
  ];

  home.username = "britt";
  home.homeDirectory = "/home/britt";
  home.stateVersion = "22.05";

  home.sessionPath = [
    utils
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Pending https://gitlab.com/rycee/nmd/-/merge_requests/6
  manual.manpages.enable = false;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv.enable = true;

  home.packages = with pkgs; [
    htop
    tree
    fzf
    silver-searcher
    jq
    yq
    dig
    gnupg
    go_1_18
    gopls
    gocode
    delve
    tmux
    git
    nix
    direnv
    stern
    (python39.withPackages (pp: with pp; [
      pynvim
    ]))
  ];
}
