# user

Primary Unix account, per-user packages, git identity, and `gh` for `config.common.username`.

- `default.nix` — `users.users` (`isNormalUser`, groups, packages), HM wrapper (git)
- `home-manager.nix` — `gh`, generic shell integration for HM programs

Requires `./common`. Does not set login shell (see `shell/`) or GNOME dconf (see `desktop/`). Importer may combine with feature modules; attrs merge on rebuild.
