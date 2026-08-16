{ config, inputs, ... }:
{
  flake.modules.darwin.mba =
    { pkgs, ... }:
    {
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      system.stateVersion = 6;

      environment.systemPackages = with pkgs; [
        git
        neovim
        lazygit
        fastfetch
        just
        nixos-anywhere
      ];
    };

  flake.darwinConfigurations.mba = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs; };
    modules = [
      { nixpkgs.hostPlatform = "aarch64-darwin"; }
      config.flake.modules.darwin.mba
    ];
  };
}
