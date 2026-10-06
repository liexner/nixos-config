{ inputs, config, ... }:
let
  home-manager-config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      # home.username/homeDirectory are derived by home-manager from users.users.<name>
      sharedModules = [ config.flake.modules.homeManager.common ];
    };
  };
in
{
  flake.modules.nixos.home-manager = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      home-manager-config
    ];
  };

  flake.modules.darwin.home-manager =
    { config, ... }:
    let
      user = config.system.primaryUser;
    in
    {
      imports = [
        inputs.home-manager.darwinModules.home-manager
        home-manager-config
      ];
      users.users.${user}.home = "/Users/${user}";
      home-manager.users.${user} = { };
    };
}
