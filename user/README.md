# user

Primary user account and per-user Home Manager extras for `config.common.username`.

- `default.nix` — `users.users`, package list, HM wrapper (git)
- `home-manager.nix` — gh, fish integration, dconf activation
- `dconf/` — GNOME keyfile; see [dconf/README.md](dconf/README.md)

Requires `./common`. Git identity uses `common.username` and `common.email` in the HM wrapper in `default.nix`.
