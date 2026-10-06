{ config, ... }:
{
  flake.modules.darwin.m1.system.primaryUser = "linusexner";

  flake.darwinConfigurations.m1 = config.flake.lib.mkDarwin [ config.flake.modules.darwin.m1 ];
}
