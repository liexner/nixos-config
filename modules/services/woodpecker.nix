{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 9000 ];

  services.woodpecker-server = {
    enable = true;
    # environment variables required by Woodpecker
    environment = {
      WOODPECKER_OPEN = "true";              # open signup for simplicity
      WOODPECKER_HOST = "http://localhost:9000";
      WOODPECKER_ADMIN = "admin";           # initial admin user
      WOODPECKER_AGENT_SECRET = "super-secret"; # shared secret for agents
      WOODPECKER_DATABASE_DRIVER = "sqlite3";
      WOODPECKER_DATABASE_DATASOURCE = "/var/lib/woodpecker/woodpecker.sqlite";
    };
    dataDir = "/var/lib/woodpecker"; # where database + repos will be stored
  };

  services.woodpecker-agent = {
    enable = true;
    environment = {
      WOODPECKER_SERVER = "http://localhost:9000"; # point to your server
      WOODPECKER_AGENT_SECRET = "super-secret";    # same secret as server
      WOODPECKER_AGENT_NAME = "main-agent";        # optional
    };
  };

  # Ensure Woodpecker storage exists
  systemd.tmpfiles.rules = [
    "d /var/lib/woodpecker 0755 root root -"
  ];





}
