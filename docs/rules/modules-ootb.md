# Module OOTB checklist

Each importable module under `src/` should work on a fresh NixOS install when combined with only the imports listed below (plus host **hardware**: `fileSystems`, `boot.loader`, drivers). Identity comes from **`./common`**; Home Manager is pulled in by `common`, not by feature modules.

| Module | Minimum imports | Owns (out of the box) | Host still required |
| ------ | ----------------- | --------------------- | ------------------- |
| `common` | — | HM tarball, `common.*` options, primary-user HM `stateVersion` | `system.stateVersion` if no other module sets it |
| `system` | optional | auto-upgrade channel, locale, openssh, PipeWire, sudo, rtkit, base packages, `allowUnfree` | boot, disks, networking policy |
| `user` | `common` | normal user, wheel + NM groups, NM enabled, `allowUnfree`, git/gh HM, app packages | password or auth for the account |
| `shell` | `common` | fish login shell, HM fish/starship/lsd/direnv | — (defaults `isNormalUser`) |
| `terminal` | `common` | Ghostty, tmux, HM fonts; defaults fish login shell | full fish stack if you want `shell/` snippets without importing `shell` |
| `tty` | none | kmscon, console fonts | — |
| `editor` | none | Neovim, LSP/format tools, nerd font, `MANPAGER` | — |
| `desktop` | `common` | GNOME, GDM, ibus, PipeWire, GTK/Qt HM, dconf | GPU/display if not generic |
| `keyboard` | `common` | kanata, uinput/input groups | — (defaults `isNormalUser`) |
| `music` | `common` | PipeWire (low latency), JACK, rtkit, `allowUnfree`, guitar/DAW packages | — (defaults `isNormalUser`) |

Duplicated attrs (PipeWire, `allowUnfree`, fish, `isNormalUser`) across modules are intentional; Nix merges them. Prefer enabling a concern in every module that needs it rather than assuming `./system` is always imported.

See [nix-modules.md](nix-modules.md) (import enables; host overrides only) and ADRs [0017](../decisions/0017-module-ootb-over-dry.md), [0024](../decisions/0024-import-enables-feature-modules.md).
