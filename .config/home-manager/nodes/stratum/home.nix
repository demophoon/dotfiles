{ config, pkgs, ... }:

let
  cfg = config.dotfiles.install;
in {
  imports = [
    ../default
    ../../roles/sway
  ];

  home.packages = with pkgs; [
    qmk_hid
  ];

}
