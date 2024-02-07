{ config, pkgs, lib, builtins, ... }:

{
  home.username = "root";
  home.homeDirectory = "/root";

  imports = [
    ./nodes/default
  ];

  home.file.".localrc".source = pkgs.writeText ".localrc" "if [ -z $__first_login ]; then; export __first_login=1; cd ~ubuntu; fi; source ~ubuntu/.localrc;";
}
