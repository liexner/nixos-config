{
  description = "My multi-host NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    agenix.url = "github:ryantm/agenix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, disko, agenix, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      secrets = ./secrets;
    in
    {
      nixosConfigurations = {

        tower = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/_common/default.nix
            ./hosts/tower/configuration.nix
          ];
        };

        elitedesk = lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko
            agenix.nixosModules.default
            ./hosts/_common/default.nix
            ./hosts/elitedesk/configuration.nix
            ./hosts/elitedesk/disko.nix
          ];
        };

        wsl = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            nixos-wsl.nixosModules.default
            agenix.nixosModules.default
            ./hosts/_common/default.nix
            ./hosts/wsl/configuration.nix
          ];
        };



      };
    };
}
