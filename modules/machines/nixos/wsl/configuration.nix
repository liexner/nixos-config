{ config, lib, pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "liexner";

  environment.systemPackages = with pkgs; [
    neofetch
    go
    bun
    nixos-anywhere
  ];

  # Define user account
  users.users.liexner = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "nixos";
  };
}
