# Nix modules

## Machine-only (`configuration.nix`)

- `boot`, hostname, wireless/network setup, hardware-specific session vars (e.g. iGPU `MESA_*` on X230T)

## System fragments (`system/`)

Purpose-named files (`autoupgrade.nix`, `services.nix`, …): channel auto-upgrade, locale, base services, docs. Optional per machine; not a substitute for machine-only attrs above.

## Elsewhere

`hardware-configuration.nix`, much of `user/default.nix`: disk, per-user packages

## common/

- Imports Home Manager (`fetchTarball` + `"${home-manager}/nixos"`)
- `home-manager.backupFileExtension`, primary-user HM `stateVersion`
- Options: `common.username`, `common.email`, `common.home.stateVersion`

Import **`./common`** before `shell/`, `terminal/`, `user/`, and other HM feature modules.

## Feature modules

`shell/`, `terminal/`, `desktop/`, `editor/`, `keyboard/`:

- Use `config.common.username`; no hardcoded login names
- Do not import Home Manager themselves

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
