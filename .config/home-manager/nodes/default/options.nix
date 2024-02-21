{ config, pkgs, options, lib, ... }:

let
  cfg = config.dotfiles.install;
in {
  options.dotfiles.install = with lib; {
    username = mkOption {
      type = with types; str;
      default = "britt";
      description = "Username of user installing dotfiles";
    };
    packages = mkOption {
      type = with types; listOf str;
      default = [];
      description = "Extra packages to install";
    };
  };
}
