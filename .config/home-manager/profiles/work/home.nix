{ config, pkgs, ... }:

{
  home.username = "brittgresham";
  home.homeDirectory = "/Users/brittgresham";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    ../default
  ];
}
