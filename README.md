# X230T

NixOS config for the ThinkPad X230T. `configuration.nix` lists module imports and machine-only settings. Importable modules are **git submodules** under `src/` (separate repos `rraafays/<name>.nix`).

## Clone

```bash
git clone --recurse-submodules https://github.com/rraafays/X230T.git
```

See [docs/rules/submodules.md](docs/rules/submodules.md) for update and bump workflows.

## Layout

| Path | Role |
| ---- | ---- |
| `configuration.nix` | Imports, boot, hostname, wireless, iGPU session vars |
| `hardware-configuration.nix` | Disk, firmware, platform |
| `src/common` | Submodule: Home Manager bootstrap, `common.*` options |
| `src/system` | Submodule: NixOS fragments (autoupgrade, services, …) |
| `src/user` | Submodule: user account, packages, git/gh |
| `src/shell` | Submodule: fish, starship, lsd |
| `src/terminal` | Submodule: Ghostty, tmux |
| `src/desktop` | Submodule: GNOME, GTK/Qt, ibus, dconf |
| `src/editor` | Submodule: system Neovim |
| `src/keyboard` | Submodule: Kanata |
| `docs/decisions/` | MADR records |
| `docs/rules/` | Project rules |

## configuration.nix

Module imports plus settings that must not be imported on other machines (boot device, hostname, wireless, this laptop’s iGPU `MESA_*` overrides). See [ADR 0016](docs/decisions/0016-common-module-and-skeleton-configuration.md).

## Common options

```nix
common.username = "raf";
common.email = "you@example.com";
common.home.stateVersion = "26.05";
```

See [src/common/README.md](src/common/README.md).

## Import elsewhere

In another NixOS host repo, use the same **`src/<name>/`** layout and add only the submodules you need:

```bash
mkdir -p src
git submodule add https://github.com/rraafays/common.nix.git src/common
git submodule add https://github.com/rraafays/shell.nix.git src/shell
git submodule update --init --recursive
```

Other module URLs: `system.nix`, `user.nix`, `terminal.nix`, `desktop.nix`, `editor.nix`, `keyboard.nix` on `github.com/rraafays/`.

Wire them in `configuration.nix` (always **`./src/common`** before Home Manager modules):

```nix
{
  imports = [
    ./hardware-configuration.nix
    ./src/common
    ./src/shell
  ];

  common.username = "you";
  common.email = "you@example.com";
  common.home.stateVersion = "26.05";

  users.users.you = { isNormalUser = true; };
}
```

Each module README lists prerequisites (e.g. `shell` expects a `users.users.<common.username>` entry; import `./src/user` or define that user yourself).
