{ config, pkgs, ... }:

{
  services.home-assistant = {
    enable = true;
    openFirewall = true;
    configDir = "/var/lib/hass";
    configWritable = true;
  };
}
