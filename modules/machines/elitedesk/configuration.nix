{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/services/home-assistant.nix
    ../../modules/services/newt.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "elitedesk";
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    htop
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  security.sudo.wheelNeedsPassword = false;



}
