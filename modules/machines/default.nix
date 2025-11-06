{ lib, self, ... }:
let
  entries = builtins.attrNames (builtins.readDir ./.);
  configs = builtins.filter (
    dir: dir != "_common" && builtins.pathExists (./. + "/${dir}/configuration.nix")
  ) entries;
in
{
  flake.nixosConfigurations = lib.listToAttrs (
    builtins.map (name: lib.nameValuePair name (
      self.inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit (self) inputs; };
        modules = [
          self.inputs.disko.nixosModules.disko
          self.inputs.agenix.nixosModules.default
          self.inputs.nixos-wsl.nixosModules.default
          ./_common/default.nix
          (./. + "/${name}/configuration.nix")
        ];
      }
    )) configs
  );
}
