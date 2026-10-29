{ den, ... }:
{
  den.aspects.home-assistant = {
    includes = [ den.aspects.caddy den.aspects.secrets ];

    nixos = { config, ... }: {

      services.home-assistant = {
        enable = true;
        extraComponents = [ "default_config" "zha" "met" "samsungtv" ];
        config.homeassistant = { };
        config.default_config = { };
        config.http = {
          trusted_proxies = [ "127.0.0.1" "::1" ];
          use_x_forwarded_for = true;
        };

        config."automation ui" = "!include automations.yaml";
        config."scene ui" = "!include scenes.yaml";
        config."script ui" = "!include scripts.yaml";
      };
      systemd.tmpfiles.rules = [
        "f /var/lib/hass/automations.yaml 0644 hass hass"
        "f /var/lib/hass/scenes.yaml 0644 hass hass"
        "f /var/lib/hass/scripts.yaml 0644 hass hass"
      ];
      users.users.hass.extraGroups = [ "dialout" ];

      services.caddy.virtualHosts."hass.exner.dev".extraConfig = ''
        reverse_proxy localhost:8123
      '';

      # Exposes chosen HA entities to Google Home as a Matter bridge; web UI on :8482
      sops.secrets.home-assistant-matter-hub = { };
      services.home-assistant-matter-hub = {
        enable = true;
        openFirewall = true;
        accessTokenFile = config.sops.secrets.home-assistant-matter-hub.path;
        settings.homeAssistantUrl = "http://localhost:8123";
      };

      networking.firewall.allowedTCPPorts = [ 8123 8482 ];
      networking.firewall.allowedUDPPorts = [ 5353 ]; # mDNS
    };


  };
}
