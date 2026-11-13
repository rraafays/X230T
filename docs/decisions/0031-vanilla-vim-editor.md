# Vanilla Vim editor module

## Context and Problem Statement

Neovim, Tree-sitter bundles, plugin stacks, and custom `MANPAGER` wiring were more moving parts than needed. The editor module should be plain Vim from nixpkgs: no plugins, built-in syntax highlighting, default editor only; `man` should keep the stock pager.

## Considered Options

- Stock Neovim with Tree-sitter parsers on `rtp`
- Stock Vim with a short `/etc/vimrc` and `MANPAGER=vim +Man!`
- Stock Vim with a short `/etc/vimrc` and default `man` pager

## Decision Outcome

Chosen option: "Stock Vim with a short `/etc/vimrc` and default `man` pager", because Vim’s filetype and syntax support is enough without Neovim, Lua config, parser packages, or tying `man` to the editor binary.

### Consequences

- Good, because the module is a handful of lines and one `vim-full` package
- Good, because `man` stays on the usual pager without stale `MANPAGER` in long-lived shells
- Bad, because no LSP, completion, or Neovim-only UI niceties
- Bad, because ADRs 0009, 0013, 0021, and earlier Neovim-oriented records are partly historical
