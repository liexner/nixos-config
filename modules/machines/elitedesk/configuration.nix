{ config, lib, pkgs, ... }:

{
  imports = [
    ./disko.nix
    ../../services/home-assistant.nix  # ← Fixed: removed extra 'modules/'
    ../../services/newt.nix            # ← Fixed: removed extra 'modules/'
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
