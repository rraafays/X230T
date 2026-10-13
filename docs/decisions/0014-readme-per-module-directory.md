# README per module directory

## Context and Problem Statement

Only the root README and `user/dconf/README.md` described the tree. Importable modules had no local summary of scope, Home Manager vs NixOS, or import requirements.

## Considered Options

- Root README only
- One `README.md` per top-level module directory
- Wiki or external docs site

## Decision Outcome

Chosen option: "One `README.md` per top-level module directory", because readers opening `shell/` or `editor/` see scope immediately, and Cursor rules can require the same layout for agents.

### Consequences

- Good, because module docs sit next to the Nix they describe
- Good, because root README stays an index without every detail
- Bad, because READMEs must be updated when module behaviour changes
- Bad, because short READMEs can duplicate ADRs if both restate decisions

Related commit: `bb460d0`.
