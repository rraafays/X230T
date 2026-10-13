# Maintaining rules

## Responsibility

Anyone changing project conventions (humans or agents) keeps **`docs/rules/`** and **`.cursor/rules/`** in sync.

## Workflow

1. Decide the policy change (often captured in a MADR under `docs/decisions/` when commit-worthy).
2. Edit the relevant **`docs/rules/<topic>.md`** with full, readable explanation.
3. Edit the matching **`.cursor/rules/*.mdc`** so Cursor still applies the same rules automatically.
4. Run the headless format pass on touched markdown.

## Topic map

| `docs/rules/` | `.cursor/rules/` |
| ------------- | ---------------- |
| `philosophy.md`, `nix-modules.md` | `nix-modules-portable.mdc`, `nix-system-vs-common.mdc` |
| `documentation.md` | `readme-style.mdc`, `module-readmes.mdc` |
| `decisions.md` | `madr-adrs.mdc` |
| `formatting-and-code.md` | `format-after-edit.mdc`, `no-comments-unless-asked.mdc` |
| `maintaining-rules.md` (this file) | `docs-rules-sync.mdc` |

Cursor-only frontmatter (`alwaysApply`, `globs`) stays in `.mdc` files only.
