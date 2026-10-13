# dconf

`settings.ini` is a `dconf dump` keyfile. Home Manager runs `dconf load /` on activate when the file is non-empty.

Rebuild after edits:

```bash
sudo nixos-rebuild switch
```

## Refresh from GNOME

```bash
dconf dump / > /tmp/dconf-current.ini
diff -u desktop/dconf/settings.ini /tmp/dconf-current.ini
```

Merge wanted sections or keys into `settings.ini`, then rebuild.

Section-only diff:

```bash
diff -u <(grep '^\[' desktop/dconf/settings.ini | sort) \
        <(grep '^\[' /tmp/dconf-current.ini | sort)
```

`meld desktop/dconf/settings.ini /tmp/dconf-current.ini` works for side-by-side edits.

Check activation:

```bash
systemctl --user status home-manager-raf.service
```

Empty arrays need a type, e.g. `disabled-extensions=@as []`.

## Scope

Track keys for apps in `user/default.nix` (packages) and GNOME settings you want declarative. Omit one-off paths, removed apps, and hardware-specific extension state unless you intend to pin it on this machine.
