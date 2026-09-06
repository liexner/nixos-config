{
  flake.modules.homeManager.neovim =
    { pkgs, ... }:
    {
      programs.nixvim = {
        extraPackages = [
          pkgs.go # gopls shells out to `go` at runtime (module resolution, vet, etc.)
          pkgs.gofumpt # not covered by conform's autoInstall package mapping
        ];

        lsp.servers = {
          nixd = {
            enable = true;
            config.settings.nixd.options =
              if pkgs.stdenv.hostPlatform.isDarwin then
                {
                  darwin.expr = "(builtins.getFlake (builtins.toString ./.)).darwinConfigurations.mba.options";
                }
              else
                {
                  nixos.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.wsl.options";
                };
          };

          gopls = {
            enable = true;
            config.settings.gopls = {
              gofumpt = true; # use gofumpt's stricter formatting inside gopls itself
              staticcheck = true; # extra analyses beyond go vet
            };
          };

          ts_ls.enable = true; # typescript-language-server: also covers plain JS/JSX
          svelte.enable = true;

          # cssls/html/jsonls all ship in the single vscode-langservers-extracted package
          jsonls.enable = true;
          yamlls.enable = true;
          html.enable = true;
          cssls.enable = true;

          dockerls.enable = true; # Dockerfile
          docker_compose_language_service.enable = true; # compose.yaml/docker-compose.yaml
        };

        plugins.conform-nvim.settings.formatters_by_ft = {
          nix = [ "nixfmt" ];
          go = [
            "goimports" # fixes/organizes imports on save
            "gofumpt" # stricter superset of gofmt
          ];
          typescript = [ "prettier" ];
          typescriptreact = [ "prettier" ];
          svelte = [ "prettier" ]; # needs `prettier-plugin-svelte` as a project devDependency to format .svelte files correctly
          json = [ "prettier" ];
          yaml = [ "prettier" ];
          html = [ "prettier" ];
          css = [ "prettier" ];
        };

        extraConfigLuaPost =
          # lua
          ''
            -- ts_ls/svelte have no standalone `goimports`-style binary, so autoimport-on-save
            -- goes through the LSP's own "organize imports" code action instead of conform.
            local function organize_imports(bufnr)
              local params = vim.lsp.util.make_range_params(0, "utf-16")
              params.context = { only = { "source.organizeImports" }, diagnostics = {} }
              local results = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
              for _, res in pairs(results or {}) do
                for _, action in ipairs(res.result or {}) do
                  if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, "utf-16")
                  end
                end
              end
            end

            vim.api.nvim_create_autocmd("BufWritePre", {
              pattern = { "*.ts", "*.tsx", "*.svelte" },
              callback = function(args)
                organize_imports(args.buf)
              end,
            })
          '';
      };
    };
}
