{ inputs, self, ... }:
{
  den.aspects.tailscale.nixos = { config, ... }: {
    imports = [ inputs.agenix.nixosModules.default ];
    age.secrets.tailscale.file = self + "/secrets/tailscale.age";
    services.tailscale = {
      enable = true;
      authKeyFile = config.age.secrets.tailscale.path;
      openFirewall = true;
    };
  };
}
