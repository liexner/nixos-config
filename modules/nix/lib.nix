{ inputs, lib, config, ... }:
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

  # Every host gets common + home-manager (+ agenix on NixOS); hosts pass only what varies.
  config.flake.lib = {
    mkNixos =
      modules:
      inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.agenix.nixosModules.default
          config.flake.modules.nixos.common
          config.flake.modules.nixos.home-manager
        ] ++ modules;
      };

    mkDarwin =
      modules:
      inputs.nix-darwin.lib.darwinSystem {
        modules = [
          { nixpkgs.hostPlatform = "aarch64-darwin"; }
          config.flake.modules.darwin.common
          config.flake.modules.darwin.home-manager
        ] ++ modules;
      };
  };
}
