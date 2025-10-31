{
  description = "My multi-host NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colmena = {
      url = "github:zhaofengli/colmena";
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

    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
        };
      };

      # Deploy your server host
      server = { name, nodes, ... }: {
        deployment = {
          # Change these to match your server's actual details:
          targetHost = "192.168.50.21";  # e.g., "192.168.1.100" or "server.example.com"
          targetPort = 22;                             # SSH port
          targetUser = "liexner";                      # SSH user
        };

        imports = [
          disko.nixosModules.disko
          ./hosts/_common/default.nix
          ./hosts/server/configuration.nix
          ./hosts/server/disko.nix
        ];
      };
    };
  };
}
