# Tmux and fish display compatibility

## Context and Problem Statement

Tmux splits with fish (vi bindings, starship, tab completion on wide paths) showed blank rows, broken pane borders, and ragged completion columns. Fish’s terminal queries and focus events interact badly with tmux’s pane model; ambiguous-width characters in paths widen completion columns unevenly.

## Considered Options

- Leave tmux defaults and fish unchanged
- Disable tmux focus reporting and tune terminal features; fish workarounds when `TMUX` is set
- Drop tmux on SSH and use fish only on the host

## Decision Outcome

Chosen option: "Disable tmux focus reporting and tune terminal features; fish workarounds when `TMUX` is set", because the stack stays tmux-first while fixing the common fish/tmux failure modes without host-specific patches.

### Consequences

- Good: `terminal/` owns tmux terminfo and passthrough; `shell/` owns fish-side reflow, query, and width settings
- Good: Ghostty alt-key passthrough via `extended-keys` remains for pane navigation
- Bad: Neovim and other apps no longer receive tmux focus-in/out events (usually acceptable)
- Bad: some upstream fish pager blanking may remain until fish fixes inline completion cleanup in tmux
