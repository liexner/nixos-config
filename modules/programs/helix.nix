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
            color-modes = true;
            cursor-shape.insert = "bar";
            lsp.display-inlay-hints = true;
          };

          keys.normal.C-g = [
            ":new"
            ":insert-output lazygit"
            ":buffer-close!"
            ":redraw"
          ];

          # Interactive shell; redirect to the tty so output isn't captured into the buffer. Exit returns to helix.
          keys.normal.C-t = [
            ":new"
            ":insert-output $SHELL -i </dev/tty >/dev/tty 2>&1"
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
