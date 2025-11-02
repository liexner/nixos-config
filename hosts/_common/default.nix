{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    wget
    git
    curl
  ];

  security.sudo.wheelNeedsPassword = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";




}
