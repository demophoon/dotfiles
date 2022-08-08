{ config, pkgs, ... }:

let
  dotfiles_repo = import ./dotfiles.nix;
  utils = "${dotfiles_repo.outPath}/utils";
in {
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
    tmux
    git
    nix
    direnv
    (python39.withPackages (pp: with pp; [
      pynvim
    ]))
  ];
}