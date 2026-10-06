{ config, ... }:
{
  # liexner is the default primaryUser, nothing else differs from darwin.common
  flake.darwinConfigurations.m4 = config.flake.lib.mkDarwin [ ];
}
