{ config, lib, pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "nixos";

  environment.systemPackages = with pkgs; [
    neofetch
    go
    bun
  ];
}
