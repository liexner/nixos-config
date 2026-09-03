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
      ];
    };

  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      inputs.nixos-wsl.nixosModules.default
      inputs.agenix.nixosModules.default
      config.flake.modules.nixos.common
      config.flake.modules.nixos.wsl
      config.flake.modules.nixos.neovim
    ];
  };
}
