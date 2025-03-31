{ config, pkgs, ... }:

{
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
      local_timeout = 30;
      filter_mode = "session";
    };
  };
}
