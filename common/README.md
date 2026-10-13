# common

Cross-host options, Home Manager bootstrap, and primary-user HM `stateVersion`.

| Option | Role |
| ------ | ---- |
| `common.username` | Primary Unix / Home Manager user |
| `common.home.stateVersion` | Home Manager state version for that user |
| `common.email` | Git `user.email`; `user.name` is `common.username` |
| `common.homeManagerRelease` | Documents HM release (tarball import in `default.nix`) |

Import **`./common` first** among repo modules (before `shell/`, `terminal/`, `user/`, …). It pulls in `"${home-manager}/nixos"`, sets `home-manager.backupFileExtension`, and sets `home-manager.users.<username>.home.stateVersion`.

Defaults in `default.nix`. Override on the host:

```nix
common.username = "raf";
common.email = "you@example.com";
common.home.stateVersion = "26.05";
```

Keep `homeManagerRelease` in sync with the `fetchTarball` release in this module when upgrading channels.
