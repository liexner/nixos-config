{ config, lib, pkgs, rootPath, ... }:

{
  imports = [
    ./disko.nix
    (rootPath + "/modules/services/home-assistant.nix")
    (rootPath + "/modules/services/caddy.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "elitedesk";
  networking.networkmanager.enable = true;

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
