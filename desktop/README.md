# desktop

GNOME session, ibus, GTK/Qt theming, and declarative dconf for `config.common.username`.

- NixOS: GDM, GNOME, ibus (libpinyin), locale, excluded default apps
- Home Manager: Adwaita GTK/Qt, `dconf load` from `dconf/settings.ini` on activate

Requires `./common`. Importer must define `users.users.<common.username>` (e.g. via `./user`). Skip on headless hosts. See [dconf/README.md](dconf/README.md).
