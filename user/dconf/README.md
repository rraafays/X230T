# dconf settings

Store a **`dconf dump`** here as `settings.ini` (plain text keyfile — the same format `dconf load` reads).

Home Manager applies the file on activate (`dconf load / < settings.ini`). An empty file is skipped.

After changing `settings.ini`, rebuild:

```bash
sudo nixos-rebuild switch
```

## Capture a fresh dump

From the repo root, while logged into GNOME as `raf`:

```bash
dconf dump / > /tmp/dconf-current.ini
```

Do **not** overwrite `settings.ini` blindly — a full dump includes everything on the machine (orphan apps, old paths, hardware IDs). Use diff and merge intentionally.

## Update the repo config with diff

1. Dump the live session to a temp file (above).

2. Compare with what you track in git:

   ```bash
   diff -u user/dconf/settings.ini /tmp/dconf-current.ini | less
   ```

   Or only see which section headers differ:

   ```bash
   diff -u <(grep '^\[' user/dconf/settings.ini | sort) \
           <(grep '^\[' /tmp/dconf-current.ini | sort)
   ```

3. Copy what you want into `user/dconf/settings.ini`:

   - **Whole section:** copy the `[section/name]` block and its keys from `/tmp/dconf-current.ini` into `settings.ini` (replace the old block or add a new one).
   - **Single key:** add or change one line under the existing `[section]` in `settings.ini`.

   Side‑by‑side tools work well for this, e.g. `meld user/dconf/settings.ini /tmp/dconf-current.ini`.

4. Rebuild and confirm activation:

   ```bash
   sudo nixos-rebuild switch
   systemctl --user status home-manager-raf.service
   ```

   If `dconf load` fails, the journal usually names the key (e.g. empty arrays must be typed: `disabled-extensions=@as []`, not `disabled-extensions=[]`).

## What to merge vs skip

Prefer keeping sections that match apps in `user/default.nix` and core GNOME keys you care about (`org/gnome/desktop/*`, `org/gnome/shell`, nautilus, etc.). Often safe to **omit** from the repo dump:

- Apps you do not install or have removed from the system
- Stale `picture-uri` paths, old file-chooser “last folder” paths, notification entries for unused apps
- Machine-specific hardware (tablet IDs, PipeWire device lists in extensions) unless you want them pinned on this machine

When in doubt, add one section at a time, rebuild, and fix any `dconf load` errors before merging more.
