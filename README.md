# X230T

NixOS config for the current laptop (ThinkPad X230T). Channel-based upgrades; modules under `shell/`, `terminal/`, etc. can be imported on other NixOS hosts.

## Layout

| Path                         | Role                                                          |
| ---------------------------- | ------------------------------------------------------------- |
| `configuration.nix`          | Channel, Home Manager tarball, imports, hostname, boot        |
| `hardware-configuration.nix` | Disk, firmware, platform                                      |
| `shared/`                    | `shared.username`, `shared.home.stateVersion`, `shared.email` |
| `user/`                      | User account, packages, git/gh, dconf activation              |
| `shell/`                     | Fish, starship, lsd, git shortcuts                            |
| `terminal/`                  | Ghostty, tmux                                                 |
| `desktop/`                   | GNOME, GTK/Qt, ibus                                           |
| `editor/`                    | System Neovim (`programs.neovim`)                             |
| `keyboard/`                  | Kanata                                                        |

## Shared options

Import `./shared` before user-facing modules:

```nix
imports = [ ./shared ./shell ];
```

Host overrides (defaults are set in `shared/default.nix`):

```nix
shared.username = "raf";
shared.email = "you@example.com";
shared.home.stateVersion = "26.05";
```

Git `user.name` is `shared.username`. Git `user.email` is `shared.email`.

## Home Manager

`shell/`, `terminal/`, and `desktop/` set `home-manager.users.<shared.username>`. The host must import Home Manager and define the user account.

```nix
let
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
in
{
  imports = [
    "${home-manager}/nixos"
    ./shared
    ./shell
  ];
}
```

Use a Home Manager release that matches the NixOS channel. Define `users.users.<shared.username>` before Home Manager runs (see `user/`).

## Import example

Shell only on another host:

```nix
imports = [
  "${home-manager}/nixos"
  ./shared
  ./shell
];

shared.username = "raf";

users.users.raf = {
  isNormalUser = true;
  shell = pkgs.fish;
};
```

Import `./user` for account, git, and dconf. Skip `keyboard/` without a desktop. `editor/` is NixOS-only (no Home Manager).
