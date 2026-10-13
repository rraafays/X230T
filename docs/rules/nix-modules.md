# Nix modules

## Host-specific

Keep on the laptop host entry (`configuration.nix`, `hardware-configuration.nix`, much of `user/default.nix`):

- Disk UUIDs, firmware, boot loader device
- `networking.hostName`, channel, `system.autoUpgrade`
- Home Manager tarball URL matching the NixOS release
- Large `users.users.<name>.packages` lists and desktop-only apps
- Machine tweaks (e.g. MESA overrides)

## Importable modules

Under `shared/`, `shell/`, `terminal/`, `desktop/`, `editor/`, `keyboard/`:

- Reusable NixOS and Home Manager configuration
- Parameterised with `config.shared.username` and other `shared.*` options
- No literal primary-user login in `let` bindings—use `user = config.shared.username`

Import `./shared` before any module that targets the primary human user.

## Home Manager split

- Modules set `home-manager.users.${config.shared.username}`.
- NixOS-only values (`config.shared.email`, `home.stateVersion` for HM) are set in the **wrapper** in `user/default.nix`, not inside `user/home-manager.nix` (HM `config` is not NixOS `config`).
- Importers must add `"${home-manager}/nixos"` and define the Unix user before HM runs.

## Stack conventions

| Layer | Choice |
| ----- | ------ |
| Shell | fish, starship, lsd, zoxide, direnv (`shell/`) |
| Terminal | Ghostty launches tmux; window padding on Ghostty, not tmux (`terminal/`) |
| Editor | System Neovim, Lua in `editor/lua` (`editor/`) |
| Desktop | GNOME, GTK/Qt, ibus (`desktop/`) |
| Keyboard | Kanata system service (`keyboard/`) |

Do not introduce flakes or git submodules unless the user asks.
