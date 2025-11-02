{ config, pkgs, ... }:

{

  networking.firewall.allowedTCPPorts = [ 8123 ];

  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = [ "home-assistant:/config" ];
      image = "ghcr.io/home-assistant/home-assistant:stable";
      extraOptions = [
        "--network=host"
        "--device=/dev/serial/by-id/usb-dresden_elektronik_ingenieurtechnik_GmbH_ConBee_II_DE2480395-if00"
      ];
    };
  };


}
