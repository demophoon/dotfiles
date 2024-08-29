{ config, pkgs, ... }:

let
  cfg = config.dotfiles.install;
in {
  imports = [
    ../default/nvim.nix
  ];

}
