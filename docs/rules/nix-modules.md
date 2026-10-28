# Nix modules

## Machine-only (`configuration.nix`)

- `boot`, hostname, wireless/network setup, hardware-specific session vars (e.g. iGPU `MESA_*` on X230T)

## System fragments (`system/`)

Purpose-named files (`autoupgrade.nix`, `services.nix`, …): channel auto-upgrade, locale, base services, docs. Optional per machine; not a substitute for machine-only attrs above.

## Elsewhere

`hardware-configuration.nix`, much of `user/default.nix`: disk, per-user packages

## common (`src/common`, repo `common.nix`)

- Imports Home Manager (`fetchTarball` + `"${home-manager}/nixos"`)
- `home-manager.backupFileExtension`, primary-user HM `stateVersion`
- Options: `common.username`, `common.email`, `common.home.stateVersion`

Import **`./src/common`** before other HM feature modules on this host. See [submodules.md](submodules.md).

## Feature modules (under `src/`)

`shell`, `terminal`, `tty`, `desktop`, `editor`, `keyboard`, `music`, `user` (each a submodule or host-adjacent module):

Per-module minimum imports and owned stack: **[modules-ootb.md](modules-ootb.md)**.

- Use `config.common.username`; no hardcoded login names
- Do not import Home Manager themselves

## Import enables; host overrides

A feature submodule listed in `configuration.nix` **`imports`** is **on**. The host file is for machine-specific **overrides** (e.g. `services.music.realtimeKernel = false`), hardware, and identity — not for `services.<name>.enable = true` on every import.

- Prefer **no enable gate**, or an `enable` option that **defaults to `true`** so import alone activates the stack.
- To turn a stack off, **remove the import** or set `services.<module>.enable = false` if the module exposes opt-out.
- Do not use `lib.mkEnableOption` alone as the only way to activate a feature module (its default is `false`).

## Out of the box (module completeness)

Once a module is listed in `configuration.nix` (with `./src/common` and any imports its README names), it should **deliver what it claims** without the importer wiring extra NixOS or HM attrs for that concern.

- **Own the stack** — e.g. `shell` sets fish, login shell, and HM shell config; do not rely on `user` to set the same shell.
- **Duplication is acceptable** — repeated `users.users.<name>` fragments, split HM blocks, or overlapping attrs across modules are fine when each module stays self-contained and Nix merges cleanly.
- **Still centralise identity** — `common.username`, `common.email`, and `common.home.stateVersion` stay in `common/`; do not copy those defaults into feature modules.
- **Build is the gate** — if the full system evaluates and builds, prefer clarity and module boundaries over deduplicating every line.

## Home Manager split

- Git identity on HM: wrapper in `user/default.nix` (`common.email`, name from `common.username`)
- Not inside `user/home-manager.nix` (HM `config` ≠ NixOS `config`)

## Stack conventions

| Layer | Module |
| ----- | ------ |
| Shell | `shell/` |
| Terminal | `terminal/` |
| TTY (kmscon) | `tty/` |
| Editor | `editor/` |
| Desktop | `desktop/` |
| Keyboard | `keyboard/` |
| Music | `music/` |
