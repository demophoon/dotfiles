{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Britt Gresham";
    userEmail = "britt@brittg.com";
    signing = {
      key = "8EF14A558315B01A";
    };
    extraConfig = {
      color = {
        ui = true;
      };
      core = {
        editor = "nvim";
      };
      checkout = {
        defaultRemote = "upstream";
      };
    };
    aliases = {
      cp = "cherry-pick";
      cpc = "cherry-pick --continue";
      cpa = "cherry-pick --abort";
      dat = "clone";
      mah = "checkout";
      rekt = "reset";
      uncommit = "reset HEAD~";
    };
    ignores = [
      # Compiled source
      "*.com"
      "*.class"
      "*.dll"
      "*.exe"
      "*.o"
      "*.so"
      # Packages
      "*.7z"
      "*.dmg"
      "*.gz"
      "*.iso"
      "*.jar"
      "*.rar"
      "*.tar"
      "*.zip"
      # Logs and databases
      "*.log"
      "*.sql"
      "*.sqlite"
      # OS generated files
      ".DS_Store"
      ".DS_Store?"
      "._*"
      ".Spotlight-V100"
      ".Trashes"
      "ehthumbs.db"
      "Thumbs.db"
    ];
  };
}
