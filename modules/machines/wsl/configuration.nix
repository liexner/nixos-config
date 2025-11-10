{ config, lib, pkgs, inputs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "liexner";
  wsl.docker-desktop.enable

  environment.systemPackages = with pkgs; [
    neofetch
    go
    bun
    nixos-anywhere
    nixd
    nixpkgs-fmt
  ];

}
