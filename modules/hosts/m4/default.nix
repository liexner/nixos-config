{ config, inputs, ... }:
{
  flake.modules.darwin.m4 =
    { pkgs, ... }:
    {
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      system.stateVersion = 6;
      system.primaryUser = "liexner";

      users.users.liexner.home = "/Users/liexner";

      environment.systemPackages = with pkgs; [
        git
        lazygit
        fastfetch
        just
        nixos-anywhere
      ];

      home-manager.users.liexner = {
        home.username = "liexner";
        home.homeDirectory = "/Users/liexner";
        home.stateVersion = "25.05";
        imports = [ config.flake.modules.homeManager.neovim ];
      };
    };

  flake.darwinConfigurations.m4 = config.flake.lib.mkDarwin [
    { nixpkgs.hostPlatform = "aarch64-darwin"; }
    config.flake.modules.darwin.m4
    config.flake.modules.darwin.home-manager
  ];
}
