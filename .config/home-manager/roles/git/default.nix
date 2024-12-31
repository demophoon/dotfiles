{ config, pkgs, ... }:
let
  better_branch_script = pkgs.writeTextFile {
    name = "better-branch.sh";
    text = builtins.readFile ./better-branch.sh;
  };
in {
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
      bb = "!${better_branch_script}";
      cp = "cherry-pick";
      cpc = "cherry-pick --continue";
      cpa = "cherry-pick --abort";
      dat = "clone";
      mah = "checkout";
      rekt = "reset";
      uncommit = "reset HEAD~";
      search ="!f() { git grep -iE \"$\{*}\" $(git rev-list --max-count 5000 --all); }; f";
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
