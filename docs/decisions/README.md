# Decisions

Architecture and design decisions for this repo, recorded as [MADR](https://adr.github.io/madr/) documents.

- Template: [adr-template-minimal.md](adr-template-minimal.md) ([upstream minimal template](https://github.com/adr/madr/blob/develop/template/adr-template-minimal.md))
- New record: copy the template to `nnnn-short-title.md`, fill sections, keep numbering sequential
- Granularity: one ADR per **commit** when that commit is decision-worthy; backfill after commit if missing (see `0002-adr-granularity-per-commit.md`)

| ID   | Record |
| ---- | ------ |
| 0001 | [Record architecture decisions](0001-record-architecture-decisions.md) |
| 0002 | [ADR granularity per commit](0002-adr-granularity-per-commit.md) |
| 0003 | [Split config into importable modules](0003-split-config-into-importable-modules.md) |
| 0004 | [NixOS auto upgrade and GC](0004-nixos-auto-upgrade-and-gc.md) |
| 0005 | [Kanata restart on input hotplug](0005-kanata-restart-on-input-device-hotplug.md) |
| 0006 | [Declarative GNOME via dconf](0006-declarative-gnome-settings-via-dconf.md) |
| 0007 | [Git/gh fish shortcuts from Nix](0007-git-and-gh-fish-shortcuts-from-nix.md) |
| 0008 | [lsd as default listing](0008-lsd-as-default-listing-command.md) |
| 0009 | [Neovim as man pager](0009-neovim-as-man-pager.md) |
| 0010 | [Ghostty and tmux stack](0010-ghostty-and-tmux-terminal-stack.md) |
| 0011 | [Ghostty window padding](0011-ghostty-window-padding.md) |
| 0012 | [Shared options for portable modules](0012-shared-options-for-portable-modules.md) |
| 0013 | [Neovim built-in LSP completion](0013-neovim-built-in-lsp-completion.md) |
| 0014 | [README per module directory](0014-readme-per-module-directory.md) |
| 0015 | [Human-readable rules in docs/rules](0015-human-readable-rules-in-docs-rules.md) |
