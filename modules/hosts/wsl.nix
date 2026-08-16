{ config, inputs, ... }:
{
  flake.modules.nixos.wsl =
    { pkgs, ... }:
    {
      wsl.enable = true;
      wsl.defaultUser = "liexner";
      wsl.docker-desktop.enable = true;
      programs.nix-ld.enable = true;

      fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

      environment.systemPackages = with pkgs; [
        nixos-anywhere
        nixd
        nixpkgs-fmt
        claude-code
        neovim
        lazygit
        gcc
        openstackclient
        opentofu
        vim
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
    ];
  };
}
