{ den, ... }:
{
  den.aspects.tailscale = {
    includes = [ den.aspects.secrets ];

    nixos = { config, ... }: {
      sops.secrets.tailscale = { };
      services.tailscale = {
        enable = true;
        authKeyFile = config.sops.secrets.tailscale.path;
        openFirewall = true;
      };
    };
  };
}
