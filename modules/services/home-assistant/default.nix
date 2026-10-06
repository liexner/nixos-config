{
  flake.modules.nixos.home-assistant = { pkgs, ... }: {
    services.home-assistant = {
      enable = true;
      extraComponents = [ "default_config" "zha" "met" "matter" ];
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

    services.matter-server.enable = true;

    services.matter-server.package = pkgs.python-matter-server.overridePythonAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace matter_server/server/helpers/paa_certificates.py \
          --replace-fail "        cert = x509.load_pem_x509_certificate(pem_certificate.encode())" \
          $'        try:\n            cert = x509.load_pem_x509_certificate(pem_certificate.encode())\n        except ValueError:\n            LOGGER.warning("Skipping unparsable PAA cert %s", subject)\n            return False'
      '';
    });

    networking.firewall.allowedTCPPorts = [ 8123 ];
    networking.firewall.allowedUDPPorts = [ 5353 5540 ]; # mDNS, Matter
  };
}
