{ inputs, ... }:
{
  flake.modules.nixos.wsl =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixos-wsl.nixosModules.default
        inputs.agenix.nixosModules.default
        inputs.self.modules.nixos.common
        inputs.self.modules.nixos.cli-tools
      ];

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
        gcc
        openstackclient
        opentofu
        vim
        tmux
        dotnet-sdk
        cargo
        rustc
        unzip
      ];
    };
}
