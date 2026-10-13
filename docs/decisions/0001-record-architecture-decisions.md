# Record architecture decisions

## Context and Problem Statement

This NixOS configuration spans host-specific and importable modules. Design choices were only described in READMEs and chat. We need a durable, versioned log of decisions so future changes (new laptop, server imports, submodules) stay understandable.

## Considered Options

- MADR minimal template in `docs/decisions/`
- MADR full template in `docs/decisions/`
- README-only documentation
- No written decision log

## Decision Outcome

Chosen option: "MADR minimal template in `docs/decisions/`", because it matches the desired lean docs style, matches [MADR](https://github.com/adr/madr) tooling and conventions, and keeps enough structure (context, options, outcome, consequences) without heavy metadata.

### Consequences

- Good, because decisions are traceable in git alongside Nix and Lua changes
- Good, because importable modules and shared options can cite an ADR when behavior is non-obvious
- Good, because agents and contributors follow one template and one directory
- Bad, because each meaningful change adds a short documentation step
- Bad, because ADRs can drift if not updated when decisions are reversed
