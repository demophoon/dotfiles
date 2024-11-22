{ config, pkgs, ... }:

let
  cfg = config.dotfiles.install;
in {
  imports = [
    ../../roles/nvim
  ];

}
