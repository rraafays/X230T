# lsd as default listing command

## Context and Problem Statement

Interactive directory listings should show metadata columns and stay consistent in fish without relying on plain `ls` aliases alone.

## Considered Options

- GNU `ls` with `LS_COLORS` and aliases
- `eza` or `lsd` with Home Manager aliases and config files
- `vdir`/`dir` only

## Decision Outcome

Chosen option: "`lsd` with Home Manager aliases and config files", because `lsd` supports yaml config for colours and blocks, icons can stay off, and fish aliases (`ll`, `la`, …) in `shell/default.nix` route to one tool.

### Consequences

- Good, because listing layout and colours are declarative under `shell/lsd/`
- Good, because `lsd` is added via `home.packages` on the shell module
- Bad, because another host must package `lsd` to import the module unchanged
- Bad, because git column and patched symbols were explored separately from base `lsd` setup

Related commit: `7c9554b`.
