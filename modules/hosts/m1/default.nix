{ config, inputs, ... }:
{
  flake.modules.darwin.m1 =
    { pkgs, ... }:
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      system.stateVersion = 6;
      system.primaryUser = "linusexner";

      users.users.linusexner.home = "/Users/linusexner";

      environment.systemPackages = with pkgs; [
        git
        lazygit
        fastfetch
        just
        nixos-anywhere
        nodejs
      ];

      home-manager.users.linusexner = {
        home.username = "linusexner";
        home.homeDirectory = "/Users/linusexner";
        home.stateVersion = "25.05";
        imports = [ config.flake.modules.homeManager.neovim ];
      };
    };

  flake.darwinConfigurations.m1 = config.flake.lib.mkDarwin [
    { nixpkgs.hostPlatform = "aarch64-darwin"; }
    config.flake.modules.darwin.m1
    config.flake.modules.darwin.home-manager
  ];
}
