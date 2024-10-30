{ config, pkgs, ... }:

{
  home.username = "root";
  home.homeDirectory = "/root";

  imports = [
    ../default
  ];

  home.packages = with pkgs; [
    swagger-cli
  ];
}
