{ den, inputs, self, ... }:
{
  den.aspects.microbin = {
    includes = [ den.aspects.caddy ];

    nixos = { config, ... }: {
      imports = [ inputs.agenix.nixosModules.default ];

      age.secrets.microbin.file = self + "/secrets/microbin.age";

      services.microbin = {
        enable = true;
        passwordFile = config.age.secrets.microbin.path;
        settings = {
          MICROBIN_BIND = "127.0.0.1";
          MICROBIN_PORT = 8080;
          MICROBIN_PUBLIC_PATH = "https://p.exner.dev/";
          MICROBIN_HASH_IDS = false;
          MICROBIN_READONLY = true;
          MICROBIN_DEFAULT_PRIVACY = "unlisted";
        };
      };

      services.caddy.virtualHosts."p.exner.dev".extraConfig = ''
        reverse_proxy localhost:8080
      '';
    };
  };
}
