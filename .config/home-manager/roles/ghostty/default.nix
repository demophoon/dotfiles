{ config, pkgs, ... }:
{
  home.file.".config/ghostty/config".source = ./config;
}
