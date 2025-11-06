{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    wget
    git
    curl
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";

}
