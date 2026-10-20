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
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuublTf81/Q8xaEIftWaG6aC5EyQxJczAQVAx+dsHD2" # personal (Bitwarden)
      ]
      # TODO: drop the old RSA keys (and keys.nix) once the new key logs in everywhere
      ++ builtins.attrValues (import (self + "/keys.nix")).personal;
    };

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ git just lazygit gh claude-code sops ];
    };
  };
}
