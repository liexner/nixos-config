{ inputs, ... }:
{
  flake.modules.nixos.neovim =
    { ... }:
    {
      imports = [ inputs.nixvim.nixosModules.nixvim ];

      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
      };
    };
}
