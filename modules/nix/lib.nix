{ inputs, lib, ... }:
{
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {
    mkNixos =
      system: modules:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system modules;
        specialArgs = { inherit inputs; };
      };

    mkDarwin =
      modules:
      inputs.nix-darwin.lib.darwinSystem {
        inherit modules;
        specialArgs = { inherit inputs; };
      };
  };
}
