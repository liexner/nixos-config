{ self, config, ... }:
{
  flake.modules.nixos.common =
    { config, lib, pkgs, ... }:
    {
      users.users.liexner = {
        isNormalUser = true;
        description = "Linus";
        extraGroups = [ "wheel" "networkmanager" ];
        initialPassword = "nixos";
        openssh.authorizedKeys.keys = builtins.attrValues (import (self + "/keys.nix")).personal;
      };

      nix.settings.trusted-users = [ "root" "liexner" ];

      environment.systemPackages = with pkgs; [ wget git curl just ];

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
    };

  flake.modules.darwin.common =
    { lib, pkgs, ... }:
    {
      system.primaryUser = lib.mkDefault "liexner";

      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      system.stateVersion = 6;

      nixpkgs.config.allowUnfree = true; # claude-code, via home-manager's useGlobalPkgs

      environment.systemPackages = with pkgs; [
        git
        just
        nixos-anywhere
      ];
    };

  # User tools for every machine; applied through home-manager.sharedModules
  flake.modules.homeManager.common =
    { pkgs, ... }:
    {
      home.stateVersion = "25.05";
      imports = [ config.flake.modules.homeManager.neovim ];
      home.packages = with pkgs; [
        lazygit
        fastfetch
        gh
        nodejs
        nixd
        nixfmt
        statix
        claude-code
      ];
    };
}
