{ pkgs, rootPath, ... }:

{
  imports = [
    ./disko.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ideapad";
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    htop
  ];

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";

  security.sudo.wheelNeedsPassword = false;
}
