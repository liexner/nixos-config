{ den, ... }:
{
  den.aspects.liexner = {
    includes = [
      den.batteries.define-user   # username + home dir (nixos/darwin/hm)
      den.batteries.primary-user  # wheel, wsl.defaultUser, darwin primaryUser
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
