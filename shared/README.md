# shared

Host-level options used by importable modules.

| Option | Role |
| ------ | ---- |
| `shared.username` | Primary Unix / Home Manager user |
| `shared.home.stateVersion` | Home Manager state version for that user |
| `shared.email` | Git `user.email`; `user.name` is `shared.username` |

Import before `shell/`, `terminal/`, `desktop/`, or `user/` HM blocks:

```nix
imports = [ ./shared ];
```

Defaults live in `default.nix`. Override on the host in `configuration.nix`.
