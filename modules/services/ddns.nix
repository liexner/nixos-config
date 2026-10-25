{ den, ... }:
{
  den.aspects.ddns = {
    includes = [ den.aspects.secrets ];

    nixos = { config, ... }: {
      sops.secrets.cloudflare = { }; # token only, Zone:DNS:Edit on exner.dev
      services.cloudflare-dyndns = {
        enable = true;
        apiTokenFile = config.sops.secrets.cloudflare.path;
        domains = [ "*.exner.dev" ];
      };
    };
  };
}
