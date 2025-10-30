{ config, lib, pkgs, ... }:

{
  # Shared across all NixOS hosts
  
  # Common packages
  environment.systemPackages = with pkgs; [
    wget
    git
  ];

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Default state version
  system.stateVersion = "25.05";
}
