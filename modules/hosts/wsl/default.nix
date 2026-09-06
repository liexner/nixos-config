{ config, inputs, ... }:
{
  flake.modules.nixos.wsl =
    { pkgs, ... }:
    {
      wsl = {
        enable = true;
        defaultUser = "liexner";
        docker-desktop.enable = true;
      };
      programs.nix-ld.enable = true;

      fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      environment.systemPackages = with pkgs; [
        nixos-anywhere
        nixd
        nixpkgs-fmt
        nixfmt-rfc-style
        statix
        claude-code
        lazygit
        gcc
        openstackclient
        opentofu
        vim
        tmux
        fastfetch
        github-copilot-cli
        nodejs
      ];

      home-manager.users.liexner = {
        home.username = "liexner";
        home.homeDirectory = "/home/liexner";
        home.stateVersion = "25.05";
        imports = [ config.flake.modules.homeManager.neovim ];
      };
    };

  flake.nixosConfigurations.wsl = config.flake.lib.mkNixos "x86_64-linux" [
    inputs.nixos-wsl.nixosModules.default
    inputs.agenix.nixosModules.default
    config.flake.modules.nixos.common
    config.flake.modules.nixos.home-manager
    config.flake.modules.nixos.wsl
  ];
}
