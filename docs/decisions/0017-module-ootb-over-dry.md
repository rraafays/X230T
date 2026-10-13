# Module out-of-the-box completeness over strict DRY

## Context and Problem Statement

Importable modules were split for reuse, but importers still had to wire cross-cutting attrs (e.g. login shell in `user/` while fish lived in `shell/`). That fights the expectation that adding `./shell` to `configuration.nix` should yield a working shell stack for `common.username`.

## Considered Options

- Strict single owner per attr (e.g. only `user/` sets `users.users.*.shell`)
- Feature modules own their stack; allow duplicated or split NixOS/HM blocks across modules
- Monolithic module per machine with no duplication

## Decision Outcome

Chosen option: "Feature modules own their stack; allow duplicated or split NixOS/HM blocks across modules", because imports should match module README promises, Nix merges attrs when definitions align, and a successful system build is the practical check. Identity and HM bootstrap stay in `common/`.

### Consequences

- Good, because `./shell` (and peers) behave as documented without extra host wiring for that concern
- Good, because modules stay importable on other hosts with only `common.*` overrides
- Bad, because the same user attr may appear in more than one module until someone refactors
- Bad, because importers must still read READMEs for prerequisites (e.g. user account exists) that modules cannot invent
