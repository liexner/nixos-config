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
    };
    users.users.hass.extraGroups = [ "dialout" ];

    services.caddy.virtualHosts."hass.exner.dev".extraConfig = ''
      reverse_proxy localhost:8123
    '';

    networking.firewall.allowedTCPPorts = [ 8123 ];
  };
}
