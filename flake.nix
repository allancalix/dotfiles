{
  description = "Home Manager configurations.";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, ... }:
    let
      overlays = [
        (import ./overlays/supermaven.nix)
      ];
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        overlays = overlays;
        config = {
          allowUnfree = true;
          input-fonts.acceptLicense = true;
        };
      };
    in {
      homeConfigurations.allancalix = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          nix/home.nix
        ];
      };
    };
}
