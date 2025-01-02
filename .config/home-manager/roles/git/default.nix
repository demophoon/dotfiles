{ config, pkgs, ... }:
let
  better_branch_script = pkgs.writeTextFile {
    name = "better-branch.sh";
    text = builtins.readFile ./better-branch.sh;
    executable = true;
  };

  commit_message_template = pkgs.writeTextFile {
    name = "commit-msg";
    text = builtins.readFile ./commit-message-template;
  };

  # Github PR Fetching Helper
  fetch_pr_script = pkgs.writeTextFile {
    name = "fetch-pr";
    text = builtins.readFile ./fetch-pr.sh;
    executable = true;
  };
in {
  home.shellAliases = {
    fetch_pr = "${fetch_pr_script}";
  };

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
      commit = {
        template = "${commit_message_template}";
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
