# user

Primary user account and per-user Home Manager extras for `config.shared.username`.

- `default.nix` — `users.users`, package list, HM wrapper (git, `home.stateVersion`)
- `home-manager.nix` — gh, fish integration, dconf activation
- `dconf/` — GNOME keyfile; see [dconf/README.md](dconf/README.md)

Requires `./shared` and Home Manager on the host. Git identity comes from `shared.username` and `shared.email` in the HM wrapper in `default.nix`.
