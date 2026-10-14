# Editor Nerd Font symbols

## Context and Problem Statement

Neovim and system tooling show Nerd Font icons when `shell.nix` installs `nerd-fonts.symbols-only`, but `editor.nix` is often imported without relying on shell for fontconfig. Editor should be OOTB for glyphs on its own.

## Considered Options

- Require importers to always import `shell` before `editor`
- Add `nerd-fonts.symbols-only` only in Home Manager via `user.nix`
- Add `fonts.packages` with `nerd-fonts.symbols-only` in `editor.nix` (duplicate shell)

## Decision Outcome

Chosen option: "Add `fonts.packages` with `nerd-fonts.symbols-only` in `editor.nix` (duplicate shell)", because OOTB beats DRY and Fontconfig at the NixOS layer covers system Neovim outside HM font paths.

### Consequences

- Good, because `editor` alone delivers icon glyphs after import
- Good, because matches the symbols-only pattern already used in `shell.nix`
- Bad, because the same font package may be registered twice when both modules are imported
