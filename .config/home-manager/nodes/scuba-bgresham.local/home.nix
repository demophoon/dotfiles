{ config, pkgs, ... }:

{
  home.username = "brittgresham";
  home.homeDirectory = "/Users/brittgresham";

  imports = [
    ../default
  ];
}
