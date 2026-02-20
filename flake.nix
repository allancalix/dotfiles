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
    plan = {
      url = "github:allancalix/plan";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    utils,
    plan,
    ...
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;

          overlays = [
            (final: prev: {
              plan = plan.packages.${system}.default;
            })
          ];

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
