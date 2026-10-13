# editor

System Neovim via `programs.neovim` (no Home Manager).

- Lua config in `lua/editor/` (treesitter, LSP, conform, mini.nvim)
- System packages: nixd, nixfmt, lua-language-server, stylua, ripgrep
- `MANPAGER` → `nvim +Man!`

Import as a normal NixOS module. Batch formatting uses `editor/lua/editor/format.lua` (`vim.g.editor_format_file_list`).
