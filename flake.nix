{
  description = "My multi-host NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }@inputs:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      wsl = lib.nixosSystem {
        inherit system;
        modules = [
          nixos-wsl.nixosModules.default
          ./hosts/wsl.nix
        ];
      };
    };
  };
}
