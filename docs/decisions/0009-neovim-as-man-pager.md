# Neovim as man pager

## Context and Problem Statement

Man pages should open in the same editor used for code, with familiar navigation, instead of a separate pager with different keybindings.

## Considered Options

- Default `man` pager (`less`)
- `MANPAGER=nvim +Man!` via session variables
- Dedicated `man` plugin only inside Neovim when already open

## Decision Outcome

Chosen option: "`MANPAGER=nvim +Man!` via session variables", because `programs.neovim` is already the system editor in `editor/` and one environment variable wires all `man` invocations.

### Consequences

- Good, because man and edit share one UI
- Good, because configuration stays in `editor/default.nix`
- Bad, because cold-starting Neovim for man is heavier than `less`
- Bad, because man page feature depends on Neovim being installed on minimal systems

Related commit: `18138f2`.
