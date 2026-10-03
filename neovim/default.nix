{
  lib,
  pkgs,
  ...
}:
let
  config = pkgs.vimUtils.buildVimPlugin {
    pname = "neovim-config";
    version = "0";
    src = lib.fileset.toSource {
      root = ./.;
      fileset = ./lua;
    };
    doCheck = false;
  };
in
{
  environment.systemPackages = with pkgs; [
    nixd
    nixfmt
    lua-language-server
    stylua
    ripgrep
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          nvim-treesitter.withAllGrammars
          nvim-treesitter-textobjects
          nvim-lspconfig
          conform-nvim
          mini-nvim
          config
        ];
      };

      customLuaRC = ''
        vim.g.nixpkgs_path = "${pkgs.path}"
        require("editor")
      '';
    };
  };
}
