{ config, pkgs, ... }:

let
in {
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
      auto_sync = false;
      update_check = false;
      style = "compact";
      inline_height = 10;
      invert = true;
      workspaces = true;
      show_help = false;
      history_filter = [
        "^ls"
        "^fg"
        "^cdc"
        "^gs"
      ];
      filter_mode = "session";
    };
  };
}
