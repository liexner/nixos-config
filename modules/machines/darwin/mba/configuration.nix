{ pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = 6;

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];
}
