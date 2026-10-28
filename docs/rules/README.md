# Project rules

How we work on this NixOS configuration—for humans and for automation (including AI agents).

## Two locations

| Path | Purpose |
| ---- | ------- |
| **`docs/rules/`** (here) | Readable philosophy and conventions. Start here if you are new to the repo. |
| **`.cursor/rules/`** | Cursor-specific rule files (YAML frontmatter, `alwaysApply`, globs). Same policy, tighter wording for the IDE agent. |

When policy changes, update **both** so humans and Cursor stay aligned. See [maintaining-rules.md](maintaining-rules.md).

## Topics

| Document | Covers |
| -------- | ------ |
| [philosophy.md](philosophy.md) | Goals: one laptop, importable modules, channels, common options |
| [nix-modules.md](nix-modules.md) | Host vs module split, Home Manager via `common.nix` |
| [modules-ootb.md](modules-ootb.md) | Per-module minimum imports and OOTB ownership |
| [submodules.md](submodules.md) | `src/` layout, clone, bump pointers |
| [documentation.md](documentation.md) | READMEs, tone, module docs |
| [decisions.md](decisions.md) | MADR ADRs, commit granularity, AskQuestion |
| [git.md](git.md) | Agent git usage; commits are human-only |
| [formatting-and-code.md](formatting-and-code.md) | Neovim/conform format pass, comments policy |

Related: [docs/decisions/](../decisions/README.md) (recorded decisions), root [README.md](../../README.md) (layout).

## Agents

If you are an agent without Cursor rules loaded, read the topic files above before large changes. Prefer minimal diffs, match existing module style, and record decision-worthy choices in `docs/decisions/` when the user commits. Do not run `git commit` yourself; see [git.md](git.md).
