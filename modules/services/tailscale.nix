{ config, rootPath, ... }:

{
  age.secrets.tailscale.file = rootPath + "/secrets/tailscale.age";

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale.path;
    openFirewall = true;
  };
}
