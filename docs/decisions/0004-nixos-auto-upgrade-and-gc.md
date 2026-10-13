# NixOS automatic upgrade and garbage collection

## Context and Problem Statement

The laptop should stay on the NixOS channel with less manual `nixos-rebuild` and store maintenance, without unbounded disk use from old generations.

## Considered Options

- Manual rebuild and `nix-collect-garbage` only
- `system.autoUpgrade` on a schedule with garbage collection after switch
- Third-party deploy tools (deploy-rs, nixos-rebuild flake patterns)

## Decision Outcome

Chosen option: "`system.autoUpgrade` on a schedule with garbage collection after switch", because one declarative block in `configuration.nix` fits a single-owner laptop and reclaims store space after each automatic switch.

### Consequences

- Good, because security and channel updates apply on a predictable schedule
- Good, because GC runs as part of the configured upgrade path
- Bad, because a bad channel build can switch automatically without a human in the loop
- Bad, because rollback still relies on bootloader generations and user attention

Related commits: `4f64065`, `ab7037d`.
