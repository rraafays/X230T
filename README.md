# X230T

NixOS config for the ThinkPad X230T. `configuration.nix` lists module imports and machine-only settings; reusable fragments live under `common/`, `system/`, and feature modules.

## Layout

| Path | Role |
| ---- | ---- |
| `configuration.nix` | Imports, boot, hostname, wireless, iGPU session vars |
| `hardware-configuration.nix` | Disk, firmware, platform |
| `common/` | Home Manager bootstrap, `common.*` options |
| `system/` | Purpose-split NixOS fragments (autoupgrade, services, …) |
| `user/` | User account, packages, git/gh |
| `shell/` | Fish, starship, lsd |
| `terminal/` | Ghostty, tmux |
| `desktop/` | GNOME, GTK/Qt, ibus, dconf |
| `editor/` | System Neovim |
| `keyboard/` | Kanata |
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

See [common/README.md](common/README.md).

## Import elsewhere

```nix
{
  imports = [
    ./hardware-configuration.nix
    ./common
    ./system
    ./shell
  ];

  boot.loader.grub.device = "/dev/nvme0n1";
  networking.hostName = "my-server";

  users.users.raf = { isNormalUser = true; };
}
```

Omit `./system` or replace fragments; do not copy another machine’s `boot` or `MESA_*` block.
