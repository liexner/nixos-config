{
  flake.modules.nixos.home-assistant = {
    services.home-assistant = {
      enable = true;
      extraComponents = [ "zha" "met" ];
      config.homeassistant = { };
      config.http = {
        trusted_proxies = [ "127.0.0.1" "::1" ];
        use_x_forwarded_for = true;
      };
    };
    users.users.hass.extraGroups = [ "dialout" ];
    networking.firewall.allowedTCPPorts = [ 8123 ];
  };
}
