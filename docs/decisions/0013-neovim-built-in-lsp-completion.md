# Neovim built-in LSP completion

## Context and Problem Statement

Completion popups came from `mini.completion` with extra window hacks. Neovim 0.11+ offers `vim.lsp.completion` with simpler UI control via standard options.

## Considered Options

- Keep `mini.completion` and customise its window API
- `vim.lsp.completion` on LSP attach with minimal `convert` in `editor/lua/editor/completion.lua`
- Built-in completion only with default popup styling

## Decision Outcome

Chosen option: "`vim.lsp.completion` on LSP attach with minimal `convert` in `editor/lua/editor/completion.lua`", because it removes mini.completion maintenance, uses `completeopt` and `pumborder` from `editor/options.lua`, and keeps labels without kind clutter.

### Consequences

- Good, because less custom code for popup position and title clearing
- Good, because LSP capabilities stay in one completion module
- Bad, because behaviour depends on Neovim version bundled with NixOS
- Bad, because non-LSP completion sources need separate configuration

Related commit: `a309b82`. Removed `mini.surround` in `991315b` to keep `s` in normal mode (separate small UX choice, same editor pass).
