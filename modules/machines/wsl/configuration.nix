{ config, lib, pkgs, inputs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "liexner";

  environment.systemPackages = with pkgs; [
    neofetch
    go
    bun
    nixos-anywhere
    nixd
    nixpkgs-fmt
  ];

}
