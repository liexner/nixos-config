{ config, inputs, ... }:
{
  flake.modules.darwin.m4 = {
    system.primaryUser = "liexner";

    users.users.liexner.home = "/Users/liexner";

    home-manager.users.liexner = {
      home.username = "liexner";
      home.homeDirectory = "/Users/liexner";
    };
  };

  flake.darwinConfigurations.m4 = config.flake.lib.mkDarwin [
    { nixpkgs.hostPlatform = "aarch64-darwin"; }
    config.flake.modules.darwin.common
    config.flake.modules.darwin.m4
    config.flake.modules.darwin.home-manager
  ];
}
