{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.nixfmt
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          nvim-treesitter.withAllGrammars
          conform-nvim
        ];
      };

      customRC = ''
        set tabstop=4
        set shiftwidth=4
        set expandtab

        lua << EOF
        -- Treesitter highlighting
        vim.api.nvim_create_autocmd("FileType", {
          callback = function()
            pcall(vim.treesitter.start)
          end,
        })

        -- Format Nix files automatically on save
        require("conform").setup({
          formatters_by_ft = {
            nix = { "nixfmt" },
          },
          format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
          },
        })
        EOF
      '';
    };
  };
}
