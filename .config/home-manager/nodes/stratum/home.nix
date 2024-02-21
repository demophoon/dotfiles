{ config, pkgs, ... }:

let
  cfg = config.dotfiles.install;
in {
  imports = [
    ../default
  ];

  home.packages = with pkgs; [
    qmk_hid
  ];
}
