{ pkgs, inputs, ... }:

{
  systemd.services.tably = {
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      PORT = "3001";
      HOST = "127.0.0.1";
    };
    serviceConfig = {
      ExecStart = "${pkgs.nodejs}/bin/node ${inputs.tably.packages.x86_64-linux.default}/build";
      Restart = "always";
      DynamicUser = true;
    };
  };

  services.caddy.virtualHosts."tably.exner.dev" = {
    extraConfig = ''
      reverse_proxy localhost:3001
    '';
  };
}
