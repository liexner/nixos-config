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
        nixpkgs-fmt
        gcc
        openstackclient
        opentofu
        vim
        tmux
        github-copilot-cli
      ];

      home-manager.users.liexner = {
        home.sessionPath = [ "$HOME/.local/bin" ];
        home.packages = with pkgs; [ wrangler ];
        programs.bash.enable = true;
        programs.starship.enable = true;
      };
    };

  flake.nixosConfigurations.wsl = config.flake.lib.mkNixos [
    inputs.nixos-wsl.nixosModules.default
    config.flake.modules.nixos.wsl
  ];
}
