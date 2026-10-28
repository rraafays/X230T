# Import enables feature modules

## Context and Problem Statement

Feature submodules are added to `configuration.nix` on purpose. Requiring `services.music.enable = true` (and similar) after import duplicates that intent and diverges from modules like `shell/` that activate when imported.

## Considered Options

- Require explicit `enable = true` on the host for every feature module
- Import implies enabled; host sets only overrides
- No `enable` option at all (remove import to disable)

## Decision Outcome

Chosen option: "Import implies enabled; host sets only overrides", with optional `enable` defaulting to `true` for rare opt-out without dropping the import.

### Consequences

- Good: `configuration.nix` stays overrides and machine identity
- Good: matches OOTB README examples without redundant enable lines
- Bad: importers must know that import alone turns a stack on
