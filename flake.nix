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
          ./hosts/_common/default.nix
          ./hosts/wsl/configuration.nix
        ];
      };

      server = lib.nixosSystem {
        inherit system;
        modules = [
          disko.nixosModules.disko
          ./hosts/_common/default.nix
          ./hosts/server/configuration.nix
          ./hosts/server/disko.nix
        ];
      };
    };
  };
}
