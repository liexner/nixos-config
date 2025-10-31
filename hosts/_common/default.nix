{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    wget
    git
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";
}
