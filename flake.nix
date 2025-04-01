{
  description = "Home Manager configurations.";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    home-manager,
    utils,
    ...
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;

          overlays = [];

          config = {
            allowUnfree = true;
            input-fonts.acceptLicense = true;
          };
        };
      in {
        packages = {
          homeConfigurations.allancalix = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = [
              nix/home.nix
            ];
          };
        };
        formatter = pkgs.alejandra;
      }
    );
}
