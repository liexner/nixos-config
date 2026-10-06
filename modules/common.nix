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

      nixpkgs.config.allowUnfree = true;
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      system.stateVersion = "25.05";
    };

  flake.modules.darwin.common =
    { lib, ... }:
    {
      system.primaryUser = lib.mkDefault "liexner";

      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      system.stateVersion = 6;

      nixpkgs.config.allowUnfree = true;
    };

  # User tools for every machine; applied through home-manager.sharedModules
  flake.modules.homeManager.common =
    { pkgs, ... }:
    {
      home.stateVersion = "25.05";
      imports = [
        config.flake.modules.homeManager.neovim
        config.flake.modules.homeManager.helix
      ];
      home.packages = with pkgs; [
        git
        just
        nixos-anywhere
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
