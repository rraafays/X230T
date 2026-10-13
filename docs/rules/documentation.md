# Documentation

## Module READMEs

Each top-level module directory (`common/`, `system/`, `user/`, `shell/`, `terminal/`, `desktop/`, `editor/`, `keyboard/`) has a **`README.md`**.

Each README should state:

- What the module configures **out of the box** after import
- NixOS vs Home Manager responsibilities
- Required imports (`./common`, other modules, etc.) and anything the importer must still define (e.g. user account attrs without duplicating what this module sets)

Update the module README when behaviour changes in a meaningful way.

## Tone

- Short and direct; current layout and commands only.
- No “instead of…”, “previously…”, or retired approaches unless the user asks to document them.
- Root `README.md` is the index; module READMEs are the detail.

## Markdown format

After editing markdown, run the headless Neovim format pass (prettier for `*.md`). See [formatting-and-code.md](formatting-and-code.md).

## Decisions vs READMEs

READMEs say **what is**. **MADR** records under `docs/decisions/` say **why** for commit-worthy choices. Do not duplicate long decision narratives in READMEs if an ADR exists—link or keep README operational.
