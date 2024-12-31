{ config, pkgs, ... }:

{
  imports = [
    ../../roles/nvim
    ../../roles/zsh
    ../../roles/git
    ../../roles/ghostty
    ./tmux.nix
    ./asciinema.nix
  ];
  nixpkgs.config.allowUnfree = true;

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

    tmux
    git
    nix
    direnv
    asciinema
  ];

}
