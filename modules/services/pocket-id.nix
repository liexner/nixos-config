{ den, ... }:
{
  den.aspects.pocket-id = {
    includes = [ den.aspects.caddy den.aspects.secrets ];

    nixos = { config, ... }: {
      sops.secrets.pocket-id = { }; # ENCRYPTION_KEY, openssl rand -base64 32

      services.pocket-id = {
        enable = true;
        credentials.ENCRYPTION_KEY = config.sops.secrets.pocket-id.path;
        settings = {
          APP_URL = "https://id.exner.dev";
          TRUST_PROXY = true;
          HOST = "127.0.0.1";
          PORT = 1411;
          ANALYTICS_DISABLED = true;
        };
      };

      services.caddy.virtualHosts."id.exner.dev".extraConfig = ''
        reverse_proxy localhost:1411
      '';
    };
  };
}
