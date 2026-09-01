{ inputs, ... }:
{
  flake.modules.nixos.elitedesk =
    { pkgs, ... }:
    {
      imports = [
        ./_disko.nix
        inputs.disko.nixosModules.disko
        inputs.agenix.nixosModules.default
        inputs.self.modules.nixos.common
        inputs.self.modules.nixos.caddy
        inputs.self.modules.nixos.home-assistant
        inputs.self.modules.nixos.tailscale
      ];

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
}
