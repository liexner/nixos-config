{
  description = "My multi-host NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, disko, ... }@inputs:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      wsl = lib.nixosSystem {
        inherit system;
        modules = [
          nixos-wsl.nixosModules.default
          ./modules/machines/nixos/_common/default.nix
          ./modules/machines/nixos/wsl/configuration.nix
        ];
      };

      server = lib.nixosSystem {
        inherit system;
        modules = [
          disko.nixosModules.disko
          ./modules/machines/nixos/_common/default.nix
          ./modules/machines/nixos/server/configuration.nix
          ./modules/machines/nixos/server/disko.nix
        ];
      };
    };
  };
}
