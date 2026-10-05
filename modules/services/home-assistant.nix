{
  flake.modules.nixos.home-assistant = {
    services.home-assistant = {
      enable = true;
      extraComponents = [ "default_config" "zha" "met" ];
      config.homeassistant = { };
      config.default_config = { };
      config.http = {
        trusted_proxies = [ "127.0.0.1" "::1" ];
        use_x_forwarded_for = true;
      };
      # UI-editable files; "<name> ui" keys let these coexist with any declarative ones
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

    networking.firewall.allowedTCPPorts = [ 8123 ];
  };
}
