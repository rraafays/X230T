# system

NixOS fragments for this machine, split by purpose. Imported from `configuration.nix` as `./system`.

| File | Role |
| ---- | ---- |
| `autoupgrade.nix` | Channel version, auto-upgrade, GC, nix store settings |
| `security.nix` | sudo, rtkit |
| `locale.nix` | timezone, locales |
| `services.nix` | openssh, pipewire, printing, libinput |
| `environment.nix` | system packages, terminfo, `GOPATH` |
| `documentation.nix` | man and NixOS doc options |

Machine-unique settings (boot, hostname, wireless, iGPU `MESA_*` overrides) stay in **`configuration.nix`**, not here.
