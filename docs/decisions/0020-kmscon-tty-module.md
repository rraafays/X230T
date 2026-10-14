# kmscon TTY module

## Context and Problem Statement

The kernel virtual console cannot use the same Iosevka, Sarasa, and Nerd Font stack as Ghostty. We want a drop-in module that makes Ctrl+Alt+F1–F6 consoles usable for fish, starship, and Neovim-style glyphs without extra host wiring.

## Considered Options

- Keep default `getty` and bitmap `console.font` only
- fbterm started manually from login scripts
- `services.kmscon` in a dedicated `tty.nix` submodule with the same font list as `terminal.nix`

## Decision Outcome

Chosen option: "`services.kmscon` in a dedicated `tty.nix` submodule with the same font list as `terminal.nix`", because NixOS integrates kmscon as a getty replacement, Fontconfig fallback matches the GUI terminal stack, and the module can ship fonts OOTB when imported.

### Consequences

- Good, because importing `./src/tty` enables kmscon, `xterm-256color`, and Iosevka → Sarasa → Symbols Nerd Font
- Good, because font packages are duplicated from `terminal`/`shell` on purpose for portable OOTB builds
- Bad, because kmscon replaces kernel getty and may interact with rescue/debug expectations
- Bad, because Sarasa family name must stay aligned with fontconfig on the host
