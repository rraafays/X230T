# Split configuration into importable modules

## Context and Problem Statement

System configuration lived in a flat `configuration.nix` and scattered files. We wanted slices (shell, editor, terminal, …) that could be imported on other NixOS hosts later.

## Considered Options

- Monolithic `configuration.nix` only
- Top-level module directories with `default.nix` per concern
- Flake with `modules/` outputs

## Decision Outcome

Chosen option: "Top-level module directories with `default.nix` per concern", because it matches channel-based NixOS today, keeps imports as `./shell` without flakes, and matches how Home Manager and NixOS modules are already composed.

### Consequences

- Good, because each concern has a clear path (`shell/`, `editor/`, `terminal/`, …)
- Good, because another machine can import a subset via `configuration.nix`
- Bad, because cross-module options were not centralised until a later `shared/` module
- Bad, because module READMEs and ADRs were added later

Related commit: `c7b53a5`.
