{
  description = "Home Manager configuration of britt";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      linuxSystem = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };
        modules = [ ./home.nix ];
      };

      darwinSystem = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
        };
        modules = [ ./home.nix ];
      };

    in {

      homeConfigurations."britt@nova" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };
        modules = [ ./home.nix ];
      };

      homeConfigurations."brittgresham@Mac" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
        };
        modules = [ ./home-darwin.nix ];
      };

      # Configuration for running in coder environment at work
      homeConfigurations."root" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };
        modules = [ ./home-coder.nix ];
      };

    };
}
