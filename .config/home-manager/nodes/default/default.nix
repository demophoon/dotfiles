{ config, pkgs, ... }:

let
  dotfiles_repo = import ./dotfiles.nix;
  utils = "${dotfiles_repo.outPath}/utils";
in {
  imports = [
    ./nvim.nix
    ./zsh.nix
    ./git.nix
    ./configuration.nix
    ./tmux.nix
    ./atuin.nix
    ./asciinema.nix
    ./zoxide.nix
  ];
  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "23.05";

  home.sessionPath = [
    utils
  ];

  home.sessionVariables = {
    LD_LIBRARY_PATH = "";
  };

  # Pending https://gitlab.com/rycee/nmd/-/merge_requests/6
  manual.manpages.enable = false;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    htop
    btop
    tree
    fzf
    silver-searcher
    jq
    yq
    dig
    gnupg
    gnused
    dbeaver

    tmux
    git
    nix
    direnv
    asciinema
  ] ++ cfg.packages;

}
