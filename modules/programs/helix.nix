{
  flake.modules.homeManager.helix =
    { pkgs, ... }:
    {
      programs.helix = {
        enable = true;

        # -> ~/.config/helix/config.toml
        settings = {
          theme = "tokyonight";
          editor = {
            line-number = "relative";
            cursor-shape.insert = "bar";
            lsp.display-inlay-hints = true;
          };
          # Ctrl-g: lazygit in a scratch buffer, discarded on exit
          keys.normal.C-g = [
            ":new"
            ":insert-output lazygit"
            ":buffer-close!"
            ":redraw"
          ];
        };

        # -> ~/.config/helix/languages.toml
        languages.language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
            language-servers = [ "nixd" ];
          }
        ];
      };
    };
}
