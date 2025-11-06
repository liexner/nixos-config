{ config, lib, pkgs, inputs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "liexner";

  environment.systemPackages = with pkgs; [
    # inputs.colmena.packages.${pkgs.system}.colmena
    neofetch
    go
    bun
    nixos-anywhere
    nixd
    nixpkgs-fmt
  ];

  # Define user account
  users.users.liexner = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "nixos";
  };
}
