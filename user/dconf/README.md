# dconf settings

Store a **`dconf dump`** here as `settings.ini` (plain text keyfile — the same format `dconf load` reads).

Capture from a running GNOME session:

```bash
dconf dump / > user/dconf/settings.ini
```

After editing, rebuild:

```bash
sudo nixos-rebuild switch
```

Home Manager applies the file on activate (`dconf load / < settings.ini`). An empty file is skipped.
