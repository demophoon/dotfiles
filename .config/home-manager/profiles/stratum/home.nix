{ config, pkgs, ... }:

{
  home.username = "britt";
  home.homeDirectory = "/home/britt";

  imports = [
    ../default
  ];
}
