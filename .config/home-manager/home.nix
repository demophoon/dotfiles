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
    ./tmux.nix
    ./atuin.nix
  ];

  home.username = "britt";
  home.homeDirectory = "/home/britt";
  home.stateVersion = "23.05";

  home.sessionPath = [
    utils
  ];

  home.sessionVariables = {
    LD_LIBRARY_PATH = "";
  };

  # Pending https://gitlab.com/rycee/nmd/-/merge_requests/6
  manual.manpages.enable = false;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    htop
    btop
    tree
    fzf
    silver-searcher
    jq
    yq
    dig
    gnupg
    gnused

    tmux
    git
    nix
    direnv
  ];
}
