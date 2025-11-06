{
  description = "My multi-host NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05?shallow=true";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable?shallow=true";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix?shallow=true";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs =
    inputs@{ flake-parts, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        systems = [
          "x86_64-linux"
        ];
        imports = [
          ./modules/machines
        ];
        _module.args.rootPath = ./.;
      }
    );

  # outputs = { self, nixpkgs, nixos-wsl, disko, agenix, ... }@inputs:
  #   let
  #     system = "x86_64-linux";
  #     lib = nixpkgs.lib;
  #     secrets = ./secrets;
  #   in
  #   {
  #     nixosConfigurations = {

  #       tower = lib.nixosSystem {
  #         inherit system;
  #         modules = [
  #           ./hosts/_common/default.nix
  #           ./hosts/tower/configuration.nix
  #         ];
  #       };

  #       elitedesk = lib.nixosSystem {
  #         inherit system;
  #         modules = [
  #           disko.nixosModules.disko
  #           agenix.nixosModules.default
  #           ./hosts/_common/default.nix
  #           ./hosts/elitedesk/configuration.nix
  #           ./hosts/elitedesk/disko.nix
  #         ];
  #       };

  #       wsl = lib.nixosSystem {
  #         inherit system;
  #         specialArgs = { inherit inputs; };
  #         modules = [
  #           nixos-wsl.nixosModules.default
  #           agenix.nixosModules.default
  #           ./hosts/_common/default.nix
  #           ./hosts/wsl/configuration.nix
  #         ];
  #       };



  #     };
  #   };
}
