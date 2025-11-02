{
  description = "My multi-host NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    sops-nix.url = "github:Mic92/sops-nix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, disko, sops-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in
    {
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

        elitedesk = lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            ./hosts/_common/default.nix
            ./hosts/elitedesk/configuration.nix
            ./hosts/elitedesk/disko.nix
          ];
        };


      };
    };
}
