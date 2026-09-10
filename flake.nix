{
  description = "Home Manager configurations.";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plan = {
      url = "github:allancalix/plan";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    plan,
    ...
  }: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    pkgsFor = forAllSystems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
    homes = forAllSystems (system:
      home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.${system};
        modules = [
          ./nix/home.nix
          {home.packages = [plan.packages.${system}.default];}
        ];
      });
  in {
    # Home Manager finds this per-system output with --flake .#allancalix.
    legacyPackages = forAllSystems (system: {
      homeConfigurations.allancalix = homes.${system};
    });
    packages = forAllSystems (system: {
      default = homes.${system}.activationPackage;
    });
    checks = forAllSystems (system: {
      home = homes.${system}.activationPackage;
    });
    formatter = forAllSystems (system: pkgsFor.${system}.alejandra);
  };
}
