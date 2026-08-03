{ config, lib, pkgs, rootPath, ... }:

{
  imports = [
    ./disko.nix
    (rootPath + "/modules/services/home-assistant.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "elitedesk";
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    htop
  ];

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  security.sudo.wheelNeedsPassword = false;



}
