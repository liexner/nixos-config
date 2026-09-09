{
  flake.modules.homeManager.neovim =
    { pkgs, ... }:
    {
      programs.nixvim = {
        extraPackages = [
          pkgs.ripgrep # used by MiniPick.builtin.grep_live
        ];

        plugins.mini = {
          enable = true;
          modules = {
            statusline = { };
            files = { };
            pick = { };
            comment = { };
            diff = { };
            completion = { };
            pairs = { };
            surround = { };
          };
        };

        plugins.treesitter = {
          enable = true;
          highlight.enable = true;
          indent.enable = true;
        };

        # `S` rather than the usual `s`, since mini.surround already owns `s`/`sa`/`sd`/`sr`/...
        plugins.flash.enable = true;

        plugins.smear-cursor.enable = true;

        plugins.oil.enable = true;

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
          {
            mode = [
              "n"
              "x"
              "o"
            ];
            key = "S";
            action = "<cmd>lua require('flash').jump()<CR>";
            options.desc = "Flash jump";
          }
        ];

        lsp.keymaps = [
          {
            key = "gd";
            lspBufAction = "definition";
          }
          {
            key = "gr";
            lspBufAction = "references";
          }
          {
            key = "gi";
            lspBufAction = "implementation";
          }
          {
            key = "K";
            lspBufAction = "hover";
          }
          {
            key = "<leader>rn";
            lspBufAction = "rename";
          }
          {
            key = "<leader>ca";
            lspBufAction = "code_action";
          }
          {
            key = "<leader>lr";
            action = "<CMD>LspRestart<Enter>";
          }
        ];

        plugins.conform-nvim = {
          enable = true;
          autoInstall.enable = true; # auto-install formatter packages via Nix, no manual extraPackages needed
          settings.format_on_save = {
            lsp_format = "fallback"; # use the LSP's own formatter only if no formatter matched in languages.nix
            timeout_ms = 1000;
          };
        };
      };
    };
}
