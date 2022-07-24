{ config, pkgs, ... }:

{
  imports = [
    ./nvim.nix
    ./zsh.nix
    ./git.nix
  ];

  home.username = "britt";
  home.homeDirectory = "/home/britt";
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    htop
    tree
    fzf
    silver-searcher
    jq
    yq
    dig
    gnupg
    python310
    go
  ];
}
