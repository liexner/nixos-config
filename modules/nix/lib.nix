{ inputs, lib, ... }:
{
  options = {
    flake.lib = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = { };
    };

    # flake-parts declares `flake.nixosConfigurations` itself, but has no
    # equivalent for nix-darwin, so without this each host module's
    # `flake.darwinConfigurations.<name>` definition conflicts as an
    # undeclared, non-mergeable flake output.
    flake.darwinConfigurations = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.raw;
      default = { };
    };
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
