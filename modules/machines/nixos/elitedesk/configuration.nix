{ pkgs, rootPath, ... }:

{
  imports = [
    ./disko.nix
    (rootPath + "/modules/services/home-assistant.nix")
    (rootPath + "/modules/services/caddy.nix")
    (rootPath + "/modules/services/tably.nix")
    (rootPath + "/modules/services/tailscale.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "elitedesk";
  systemd.network.enable = true;
  networking.useNetworkd = true;

  environment.systemPackages = with pkgs; [
    vim
    htop
  ];

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



}
