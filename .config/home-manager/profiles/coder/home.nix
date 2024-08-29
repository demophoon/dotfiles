{ config, pkgs, ... }:

{
  home.username = "root";
  home.homeDirectory = "/root";

  imports = [
    ../default
  ];
}
