{ configm, pkgs, ... }:
{
  services.node-red = {
    enable = true;
    port = 1880;

  };
  services.caddy.virtualHosts."nodered.exner.dev" = {
    extraConfig = ''
      reverse_proxy localhost:1880
    '';
  };
}
