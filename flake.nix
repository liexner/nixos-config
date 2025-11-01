{
  description = "My multi-host NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, disko, colmena, ... }@inputs:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      wsl = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
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

    colmenaHive = colmena.lib.makeHive {

      meta = {
        nixpkgs = import nixpkgs {
        system = "x86_64-linux";
        };
      };

      elitedesk = { name, nodes, ... }: {
        deployment = {
          targetHost = "192.168.50.9";
          targetPort = 22;
          targetUser = "liexner";
        };

        imports = [
          disko.nixosModules.disko
          ./hosts/_common/default.nix
          ./hosts/elitedesk/configuration.nix
          ./hosts/elitedesk/disko.nix
        ];
      };
    };
  };
}
