# common module and skeleton configuration.nix

## Context and Problem Statement

Cross-host options lived under `shared/` and each machine duplicated Home Manager `fetchTarball` imports in `configuration.nix`. We want `common/` to bootstrap HM and identity options, a clear module list per machine, and a split between settings unique to one piece of hardware versus fragments another machine might reuse.

## Considered Options

- Keep `shared/` and HM import in each `configuration.nix`
- Rename to `common/`, HM in `common/`, all system settings in one monolithic module
- `common/` plus `configuration.nix` as imports plus machine-only attrs; `system/` as purpose-named files (e.g. `autoupgrade.nix`)

## Decision Outcome

Chosen option: "`common/` plus `configuration.nix` as imports plus machine-only attrs; `system/` as purpose-named files", because importers add `./common` once (HM + `backupFileExtension` + `stateVersion` + options), `configuration.nix` lists modules and holds values that must not travel to other machines (boot, hostname, wireless, GPU-specific session vars), and `system/` stays readable via one file per concern. The directory is named **`system/`** (not `host/`) to mean “this machine’s NixOS layer” without clashing with `networking.hostName` or “host” jargon.

### Consequences

- Good, because `common` + feature modules work on another box without inheriting X230T boot disk or iGPU hacks
- Good, because `configuration.nix` shows imports and machine-only knobs in one place
- Good, because `system/autoupgrade.nix` and similar files are easy to copy or omit per machine
- Bad, because HM release in `common/default.nix` `let` must be edited when bumping channel
- Bad, because some judgment is needed: machine-only vs `system/` fragment vs importable feature module

**Machine-only in `configuration.nix` (this laptop):** `boot`, `networking.hostName`, wireless, firewall, `MESA_GL_VERSION_OVERRIDE` / `MESA_GLSL_VERSION_OVERRIDE` for the iGPU.

**Not in importable feature modules:** anything tied to one hostname, disk, GPU, or WLAN setup.

Related commits: `common/`, split `system/` (formerly `host/`), skeleton plus machine attrs in `configuration.nix`.
