# Formatting and code style

## Format after edit

Files listed in `src/editor/lua/editor/tools.lua` (`formatters`) must be formatted before a task is done.

Use one **synchronous** headless Neovim session from the repo root (not background `nvim`). Prepend `./src/editor` to rtp and `require('editor.format')` so the repo’s `format.lua` is used. Include **submodule** paths (see `.cursor/rules/format-after-edit.mdc`).

For a few paths:

```bash
nvim --headless \
  "+lua vim.opt.rtp:prepend(vim.fn.getcwd() .. '/src/editor'); if vim.loader then vim.loader.reset() end; for k in pairs(package.loaded) do if type(k)=='string' and k:find('^editor') then package.loaded[k]=nil end end; require('editor.format'); vim.g.editor_format_file_list({ 'path/one.md', 'path/two.nix' })" \
  "+qa"
```

Markdown uses **prettier** via conform.

## Comments

Do not add comments to code, config, or scripts unless the user explicitly asks for that task. Prefer clear naming and structure. If the user asks for comments, add only what they requested.
