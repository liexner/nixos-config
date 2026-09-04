{ inputs, ... }:
{
  flake.modules.nixos.neovim =
    { pkgs, ... }:
    {
      imports = [ inputs.nixvim.nixosModules.nixvim ];

      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;

        colorschemes.tokyonight.enable = true;

        globals.mapleader = " ";

        extraPackages = [ pkgs.ripgrep ];

        plugins.mini = {
          enable = true;
          modules = {
            statusline = { };
            files = { };
            pick = { };
          };
        };

        keymaps = [
          {
            mode = "n";
            key = "<leader>e";
            action = "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>";
            options.desc = "Open file explorer";
          }
          {
            mode = "n";
            key = "<leader>ff";
            action = "<cmd>lua MiniPick.builtin.files()<CR>";
            options.desc = "Find files";
          }
          {
            mode = "n";
            key = "<leader>fg";
            action = "<cmd>lua MiniPick.builtin.grep_live()<CR>";
            options.desc = "Grep in files";
          }
        ];
      };
    };
}
