{ config, pkgs, ... }:

{
  home.username = "root";
  home.homeDirectory = "/root";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    ./roles/zsh
    ./roles/nvim
    ./roles/git
  ];
}
