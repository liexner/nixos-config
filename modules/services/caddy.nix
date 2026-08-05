{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."hass.exner.dev" = {
      extraConfig = ''
        reverse_proxy localhost:8123
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
