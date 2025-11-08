{ config, lib, pkgs, ... }:

let
  sshKeys = import ../../../ssh-keys.nix;
in
{

  users.users.liexner = {
      isNormalUser = true;
      description = "Linus Exner Ådemark";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      initialPassword = "nixos";
      openssh.authorizedKeys.keys = sshKeys.mySSHKeys;
    };

  #security.sudo.wheelNeedsPassword = false;
  nix.settings.trusted-users = [ "root" "liexner" ];


  environment.systemPackages = with pkgs; [
    wget
    git
    curl
  ];

  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";

}
