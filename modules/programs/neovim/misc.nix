{
  flake.modules.homeManager.neovim =
    { pkgs, ... }:
    {
      programs.nixvim = {
        ########
        # WSL
        ########

        clipboard.register = "unnamedplus";

        autoCmd = [
          {
            event = "TextYankPost";
            callback.__raw = "function() vim.highlight.on_yank() end";
          }
        ];

        extraConfigLuaPre =
          # lua
          ''
            -- clip.exe / powershell.exe are on PATH by default via WSL interop, no
            -- extra package needed. Paste is a bit slow since powershell.exe has to
            -- spin up each time; switch to win32yank.exe later if that's annoying.
            if vim.fn.has("wsl") == 1 then
              vim.g.clipboard = {
                name = "wsl-clipboard",
                copy = {
                  ["+"] = "clip.exe",
                  ["*"] = "clip.exe",
                },
                paste = {
                  ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                  ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                },
                cache_enabled = false,
              }
            end
          '';

        ########
        # Git
        ########

        extraConfigLuaPost =
          # lua
          ''
            -- Run a command (or the shell) in a centered floating terminal.
            local function toggle_floating_term(cmd)
              local buf = vim.api.nvim_create_buf(false, true)
              local width = math.floor(vim.o.columns * 0.9)
              local height = math.floor(vim.o.lines * 0.9)
              local win = vim.api.nvim_open_win(buf, true, {
                relative = "editor",
                width = width,
                height = height,
                row = math.floor((vim.o.lines - height) / 2),
                col = math.floor((vim.o.columns - width) / 2),
                style = "minimal",
                border = "rounded",
              })
              vim.fn.jobstart(cmd, {
                term = true,
                on_exit = function()
                  if vim.api.nvim_win_is_valid(win) then
                    vim.api.nvim_win_close(win, true)
                  end
                end,
              })
              vim.cmd("startinsert")
            end

            -- Open lazygit (push/pull/merge/branch/etc.) in a floating terminal.
            -- Reuses the system lazygit install rather than a separate git plugin.
            vim.keymap.set("n", "<leader>gg", function()
              toggle_floating_term("lazygit")
            end, { desc = "Open lazygit" })

            -- Floating scratch terminal for arbitrary commands.
            vim.keymap.set("n", "<leader>tt", function()
              toggle_floating_term(vim.o.shell)
            end, { desc = "Open floating terminal" })
          '';
      };
    };
}
