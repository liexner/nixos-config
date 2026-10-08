{ den, self, ... }:
{
  den.aspects.liexner = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      den.aspects.helix
    ];

    user = {
          description = "Linus";
          openssh.authorizedKeys.keys = builtins.attrValues (import (self + "/keys.nix")).personal;
    };

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ git just lazygit gh ];
    };
  };
}
