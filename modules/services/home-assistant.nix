{ config, pkgs, ... }:

{

  networking.firewall.allowedTCPPorts = [ 8123 ];

  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = [ "home-assistant:/config" ];
      # environment.TZ = "Europe/Berlin";
      image = "ghcr.io/home-assistant/home-assistant:stable";
      extraOptions = [
        "--network=host"
        # Use by-id path for stability
        # "--device=/dev/serial/by-id/YOUR-DEVICE-ID"
        # Or pass entire USB bus if you have multiple devices
        # "--device=/dev/bus/usb"
      ];
    };
  };

  # services.home-assistant = {
  #   enable = true;
  #   openFirewall = true;
  #   configDir = "/var/lib/hass";
  #   configWritable = true;
  #   config = {
  #     default_config = {};
  #   };
  # };
  #


}
