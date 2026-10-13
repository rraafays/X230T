# shell

Fish, starship, lsd, zoxide, direnv, and git/gh fish shortcuts for `config.common.username`.

- NixOS: `programs.fish`, login shell (`pkgs.fish`) for `common.username` and root, root HM starship
- Home Manager: aliases (`ll` → `lsd`), `conf.d` fish snippets, starship toml, lsd yaml

Requires `./common`. Importer must define `users.users.<common.username>` (e.g. `isNormalUser`); this module sets that user’s `shell`.

Subpaths: `fish/`, `lsd/`, `starship/`.
