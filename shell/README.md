# shell

Fish, starship, lsd, zoxide, direnv, and git/gh fish shortcuts for `config.shared.username`.

- NixOS: `programs.fish`, root shell and root HM starship
- Home Manager: aliases (`ll` → `lsd`), `conf.d` fish snippets, starship toml, lsd yaml

Requires `./shared` and `"${home-manager}/nixos"`. Importer must define `users.users.<shared.username>`.

Subpaths: `fish/` (generated shortcuts from `git-gh-fish.nix`), `lsd/`, `starship/`.
