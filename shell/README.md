# shell

Fish, starship, lsd, zoxide, direnv, and git/gh fish shortcuts for `config.common.username`.

- NixOS: `programs.fish`, root shell and root HM starship
- Home Manager: aliases (`ll` → `lsd`), `conf.d` fish snippets, starship toml, lsd yaml

Requires `./common` (Home Manager and `stateVersion`). Importer must define `users.users.<common.username>`.

Subpaths: `fish/`, `lsd/`, `starship/`.
