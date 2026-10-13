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

`shell`, `terminal`, `desktop`, `editor`, `keyboard` (each a submodule):

- Use `config.common.username`; no hardcoded login names
- Do not import Home Manager themselves

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
| Editor | `editor/` |
| Desktop | `desktop/` |
| Keyboard | `keyboard/` |
