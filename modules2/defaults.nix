{ lib, den, ... }:
let
  shared = {
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };

    hm.home-manager = {
       useGlobalPkgs = true;
       useUserPackages = true;
       backupFileExtension = "backup";
     };
in
{
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
  den.default.includes = [ den.batteries.hostname ];
  den.schema.hm-host.includes = [ { nixos = hm; darwin = hm; } ];

  den.default.nixos = { pkgs, ... }: {
    imports = [ shared ];
    system.stateVersion = "25.05";
    time.timeZone = "Europe/Stockholm";
    environment.systemPackages = with pkgs; [ wget git curl just ];
  };

  den.default.darwin = {
    imports = [ shared ];
    system.stateVersion = 6;
  };

  den.default.homeManager.home.stateVersion = "25.05";
}
