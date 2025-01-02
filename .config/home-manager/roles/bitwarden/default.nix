{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    bitwarden-cli
  ];
}
