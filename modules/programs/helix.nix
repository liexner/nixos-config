{
  flake.modules.homeManager.helix =
    { pkgs, ... }:
    {
      programs.helix = {
        enable = true;

        settings = {
          theme = "tokyonight";
          editor = {
            line-number = "relative";
            cursor-shape.insert = "bar";
            lsp.display-inlay-hints = true;
          };

          keys.normal.C-g = [
            ":new"
            ":insert-output lazygit"
            ":buffer-close!"
            ":redraw"
          ];
        };

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
