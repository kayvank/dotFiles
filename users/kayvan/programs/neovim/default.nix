{ config, lib, pkgs, ... }:

{
  #Some useful keybinds
  #$ go to end of the line
  #0 go to start of the line
  #shift + g go to bottom of the file
  #g + g go to start of the file
  #shift + up/down arrow scroll faster
  programs.neovim =
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in
    {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

    extraPackages = with pkgs; [
      lua-language-server

      xclip
      wl-clipboard
    ];


    plugins = with pkgs.vimPlugins; [

      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./plugin/lsp.lua;
      }

      {
        plugin = comment-nvim;
        config = toLua "require(\"Comment\").setup()";
      }

      {
        plugin = dracula-nvim;
        config = "colorscheme dracula";
      }

      {
        plugin = haskell-tools-nvim;
        config = toLuaFile ./plugin/haskell.lua;
      }

      neodev-nvim

      nvim-cmp
      {
        plugin = nvim-cmp;
        config = toLuaFile ./plugin/cmp.lua;
      }

      {
        plugin = telescope-nvim;
        config = toLuaFile ./plugin/telescope.lua;
      }

      telescope-fzf-native-nvim

      cmp_luasnip
      cmp-nvim-lsp

      luasnip
      friendly-snippets


      lualine-nvim
      nvim-web-devicons

      {
        plugin = (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-python
          p.tree-sitter-json
        ]));
        config = toLuaFile ./plugin/treesitter.lua;
      }

      vim-nix

      # {
      #   plugin = vimPlugins.own-onedark-nvim;
      #   config = "colorscheme onedark";
      # }
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./options.lua}
    '';

      extraConfig = ''
        set number
        syntax on
        set shiftwidth=2
        set smarttab
        set clipboard+=unnamedplus
      '';
    };
}
