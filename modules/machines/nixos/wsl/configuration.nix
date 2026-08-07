{ config, lib, pkgs, inputs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "liexner";
  wsl.docker-desktop.enable = true;
  programs.nix-ld.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    nixos-anywhere
    nixd
    nixpkgs-fmt
    claude-code
    neovim
    lazygit
    gcc
    openstackclient
    opentofu
];

}
