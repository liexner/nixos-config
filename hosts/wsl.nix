{ config, lib, pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "nixos";

  environment.systemPackages = with pkgs; [
    wget
    git
    neofetch
    go
    bun
  ];

  system.stateVersion = "25.05";
}
