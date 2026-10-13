# Shared options for portable modules

## Context and Problem Statement

Importable modules repeated the primary login name and Home Manager `stateVersion`. That drifts from host config and blocks reusing modules on another NixOS machine with the same or different username.

## Considered Options

- Hardcoded username in each module
- `_module.args.username` passed at every import site
- NixOS option module `shared/` with `shared.username`, `shared.email`, `shared.home.stateVersion`

## Decision Outcome

Chosen option: "NixOS option module `shared/` with `shared.username`, `shared.email`, `shared.home.stateVersion`", because one host-level setting feeds all `home-manager.users.${user}` blocks, git identity uses `shared.email`, and imports stay `./shared` plus `./shell` without extra args.

### Consequences

- Good, because modules read `config.shared.username` instead of a fixed string
- Good, because git `user.name` tracks username and email is centralised
- Bad, because Home Manager-only files cannot read NixOS `config.shared` without the wrapper in `user/default.nix`
- Bad, because importers must still import `./shared` before feature modules

Related commit: `c122d1e`.
