{ inputs, ... }:
{
  flake.modules.homeManager.neovim =
    { pkgs, ... }:
    {
      imports = [ inputs.nixvim.homeModules.nixvim ];

      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;

        colorschemes.tokyonight.enable = true;

        globals.mapleader = " ";

        opts = {
          background = "dark"; # pin dark background instead of relying on terminal auto-detection
          number = true; # line number
          relativenumber = true; # relative line numbers
          cursorline = true; # highlight current line
          wrap = false; # do not wrap lines by default
          scrolloff = 10; # keep 10 lines above/below cursor
          sidescrolloff = 10; # keep 10 lines to left/right of cursor

          tabstop = 2; # tabwidth
          shiftwidth = 2; # indent width
          softtabstop = 2; # soft tab stop not tabs on tab/backspace
          expandtab = true; # use spaces instead of tabs
          smartindent = true; # smart auto-indent
          autoindent = true; # copy indent from current line

          ignorecase = true; # case insensitive search
          smartcase = true; # case sensitive if uppercase in string
          hlsearch = true; # highlight search matches
          incsearch = true; # show matches as you type

          signcolumn = "yes"; # always show a sign column
          showmatch = true; # highlights matching brackets
          cmdheight = 1; # single line command line
          completeopt = "menuone,noinsert,noselect"; # completion options
          showmode = false; # do not show the mode, instead have it in statusline
          pumheight = 10; # popup menu height
          pumblend = 10; # popup menu transparency
          winblend = 0; # floating window transparency
          conceallevel = 0; # do not hide markup
          concealcursor = ""; # do not hide cursorline in markup
          synmaxcol = 300; # syntax highlighting limit
          fillchars = {
            eob = " ";
          }; # hide "~" on empty lines

          backup = false; # do not create a backup file
          writebackup = false; # do not write to a backup file
          swapfile = false; # do not create asswapfile
          undofile = true; # do create an undo file
          updatetime = 300; # faster completion
          timeoutlen = 500; # timeout duration
          ttimeoutlen = 10; # key code timeout (0 causes terminal query responses, e.g. background color, to fragment into literal keystrokes)
          autoread = true; # auto-reload changes if outside of neovim
          autowrite = false; # do not auto-save

          hidden = true; # allow hidden buffers
          errorbells = false; # no error sounds
          backspace = "indent,eol,start"; # better backspace behaviour
          autochdir = false; # do not autochange directories
          selection = "inclusive"; # include last char in selection
          # mouse = "a"; # enable mouse support
          modifiable = true; # allow buffer modifications
          encoding = "utf-8"; # set encoding
        };

        extraConfigLua =
          # lua
          ''
            local undodir = vim.fn.expand("~/.vim/undodir")
            if vim.fn.isdirectory(undodir) == 0 then
              vim.fn.mkdir(undodir, "p")
            end
            vim.opt.undodir = undodir

            vim.opt.iskeyword:append("-") -- include - in words
            vim.opt.path:append("**") -- include subdirs in search
          '';

        highlightOverride = {
          Normal.bg = "NONE";
          NormalNC.bg = "NONE";
          NormalFloat.bg = "NONE";
          FloatBorder.bg = "NONE";
          SignColumn.bg = "NONE";
          EndOfBuffer.bg = "NONE";
        };
      };
    };
}
