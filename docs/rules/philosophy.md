# Philosophy

## What this repo is

- NixOS configuration for **one active laptop** at a time (currently ThinkPad X230T).
- **Channel-based** upgrades (`nixos-26.05` style), not flakes, unless explicitly requested later.
- **Importable modules** (`shell/`, `terminal/`, `desktop/`, `editor/`, `keyboard/`, `user/`, `shared/`) so another NixOS host (e.g. a server) can `imports = [ ./shared ./shell ]` without copying ad hoc snippets.

## Design goals

- **Portable modules** — behaviour and dotfiles in modules; disk, hostname, and heavy package lists on the host.
- **Single identity contract** — `shared.username`, `shared.email`, `shared.home.stateVersion` on the NixOS side; modules read `config.shared.*`, not a hardcoded login that can drift.
- **Explicit Home Manager** — modules declare `home-manager.users.<username>` but do not install HM; the host wires the tarball and `users.users`.
- **Lean docs** — READMEs and rules describe **current** behaviour only; decisions worth remembering go in **MADR** under `docs/decisions/`.
- **No surprise tooling** — no capture/export scripts, flakes, or submodules unless asked.

## Out of scope by default

- Multi-machine monorepo or submodule layout (may come later).
- Documenting every package install as architecture.
- Comments in code/config unless requested—prefer naming and structure.
