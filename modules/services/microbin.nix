{ self, ... }:
{
  flake.modules.nixos.microbin =
    { config, ... }:
    {
      # env file: MICROBIN_UPLOADER_PASSWORD=...
      age.secrets.microbin.file = self + "/secrets/microbin.age";

      services.microbin = {
        enable = true;
        passwordFile = config.age.secrets.microbin.path;
        settings = {
          MICROBIN_BIND = "127.0.0.1";
          MICROBIN_PORT = 8080;
          MICROBIN_PUBLIC_PATH = "https://p.exner.dev/";
          MICROBIN_HASH_IDS = false; # animal-name URLs, easy to type on another device
          MICROBIN_READONLY = true; # uploader password is only enforced in readonly mode
          MICROBIN_DEFAULT_PRIVACY = "unlisted";
        };
      };

      services.caddy.virtualHosts."p.exner.dev".extraConfig = ''
        reverse_proxy localhost:8080
      '';
    };
}
