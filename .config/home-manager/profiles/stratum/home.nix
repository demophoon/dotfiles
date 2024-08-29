{ config, pkgs, ... }:

let
  cfg = config.dotfiles.install;
in {
  home.username = "britt";
  home.homeDirectory = "/home/britt";

  imports = [
    ../default
    ../../roles/sway
  ];

  home.packages = with pkgs; [
    qmk_hid
  ];

}
