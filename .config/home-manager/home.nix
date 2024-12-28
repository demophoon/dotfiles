{ config, pkgs, ... }:

{
  home.username = "britt";
  home.homeDirectory = "/home/britt";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    ./profiles/default
  ];
}
