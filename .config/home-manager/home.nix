{ config, pkgs, lib, builtins, ... }:

{
  home.username = "root";
  home.homeDirectory = "/root";

  imports = [
    ./nodes/default
  ];
}
