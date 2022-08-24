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
      # system = "x86_64-linux";
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.allancalix = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          .config/nixpkgs/home.nix
        ];
      };
    };
}