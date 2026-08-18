{ config, inputs, ... }:
{
  flake.modules.nixos.elitedesk =
    { pkgs, ... }:
    {
      imports = [ ./_disko.nix ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "elitedesk";
      systemd.network.enable = true;
      networking.useNetworkd = true;

      environment.systemPackages = with pkgs; [ vim htop ];

      system.autoUpgrade = {
        enable = true;
        flake = "github:liexner/nixos-config#elitedesk";
        dates = "weekly";
        allowReboot = true;
      };

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      nix.settings.auto-optimise-store = true;

      services.openssh.enable = true;
      services.openssh.settings.PermitRootLogin = "prohibit-password";

      security.sudo.wheelNeedsPassword = false;
    };

  flake.nixosConfigurations.elitedesk = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      inputs.disko.nixosModules.disko
      inputs.agenix.nixosModules.default
      config.flake.modules.nixos.common
      config.flake.modules.nixos.caddy
      config.flake.modules.nixos.home-assistant
      config.flake.modules.nixos.tailscale
      config.flake.modules.nixos.elitedesk
    ];
  };
}
