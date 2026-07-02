{ lib, self, rootPath, ... }:
let
  entries = builtins.attrNames (builtins.readDir ./.);
  configs = builtins.filter (
    dir: builtins.pathExists (./. + "/${dir}/configuration.nix")
  ) entries;
in
{
  flake.darwinConfigurations = lib.listToAttrs (
    builtins.map (name: lib.nameValuePair name (
      self.inputs.nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit (self) inputs;
          inherit rootPath;
        };
        modules = [
          { nixpkgs.hostPlatform = "aarch64-darwin"; }
          (./. + "/${name}/configuration.nix")
        ];
      }
    )) configs
  );
}
