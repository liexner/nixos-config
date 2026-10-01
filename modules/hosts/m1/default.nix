{ config, inputs, ... }:
{
  flake.modules.darwin.m1 =
    { pkgs, ... }:
    {
      system.primaryUser = "linusexner";

      users.users.linusexner.home = "/Users/linusexner";

      environment.systemPackages = with pkgs; [ nodejs ];

      home-manager.users.linusexner = {
        home.username = "linusexner";
        home.homeDirectory = "/Users/linusexner";
      };
    };

  flake.darwinConfigurations.m1 = config.flake.lib.mkDarwin [
    { nixpkgs.hostPlatform = "aarch64-darwin"; }
    config.flake.modules.darwin.common
    config.flake.modules.darwin.m1
    config.flake.modules.darwin.home-manager
  ];
}
