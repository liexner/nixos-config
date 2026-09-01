{
  flake.modules.nixos.cli-tools =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        neovim
        lazygit
        fastfetch
        nixos-anywhere
      ];
    };

  flake.modules.darwin.cli-tools =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        neovim
        lazygit
        fastfetch
        nixos-anywhere
      ];
    };
}
