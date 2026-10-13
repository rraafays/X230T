# Philosophy

## What this repo is

- NixOS configuration for **one active laptop** at a time (currently ThinkPad X230T).
- **Channel-based** upgrades, not flakes, unless explicitly requested later.
- **`configuration.nix`** lists module imports; machine-specific settings live in **`configuration.nix`** (boot, network, GPU vars) and **`src/system`** / **`hardware-configuration.nix`**.
- **Importable modules** as git submodules under **`src/`** (`common.nix`, `shell.nix`, … on GitHub) for reuse on other NixOS hosts.

## Design goals

- **`common/`** — Home Manager bootstrap, `common.username`, `common.email`, `common.home.stateVersion`.
- **Portable modules** — feature dirs own their behaviour end-to-end when imported; disk, hostname, and machine-only attrs stay on the host. Some duplication across modules is fine if each module “just works.”
- **Explicit HM wiring** — only `common/` imports `"${home-manager}/nixos"`; feature modules attach to `home-manager.users.<username>`.
- **Lean docs** — READMEs describe current behaviour; commit-worthy decisions in **MADR** under `docs/decisions/`.

## Out of scope by default

- Flakes unless asked.
- Capture/export scripts, flakes, or comments in code unless requested.
