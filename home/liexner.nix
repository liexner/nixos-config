{ config, pkgs, ... }:

{
  programs.dconf.enable = true;

  dconf.settings."org/gnome/desktop/input-sources" = {
    sources = [ ( "xkb" "se" ) ];          # Swedish layout
    xkb-options = [ "ctrl:ctrl_alt_toggle" ]; # Ctrl+Alt → AltGr
  };

  home.packages = with pkgs; [
    mesa-utils
    vulkan-tools
  ];
}
