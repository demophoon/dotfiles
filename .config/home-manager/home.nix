{ config, pkgs, lib, builtins, ... }:

{
  home.username = "britt";
  home.homeDirectory = "/home/britt";

  imports = [
    ./nodes/default
  ];
}
