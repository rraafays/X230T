# keyboard

Kanata layout, uinput group, and `input` / `uinput` membership for `config.common.username`.

NixOS only. Requires `./common`. Adds `users.users.<name>.extraGroups` and group members; importer must define that user (e.g. `./user`).
