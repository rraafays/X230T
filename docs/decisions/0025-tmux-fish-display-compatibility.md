# Tmux and fish display compatibility

## Context and Problem Statement

Tmux with fish and vi bindings showed broken completions and pane redraw glitches. Fish-specific tmux snippets did not belong in the shell-agnostic `terminal/` module.

## Considered Options

- More fish workarounds in `terminal/` (focus events, ambiguous width, repaint hooks)
- Split responsibilities: `terminal/` only Ghostty + tmux; `shell/` owns optional fish/tmux key passthrough
- Drop tmux

## Decision Outcome

Chosen option: "Split responsibilities", with tmux term settings in `terminal/` and fish `55-tmux-alt-keys` in `shell/` so Alt+arrows reach tmux for pane navigation when using fish.

### Consequences

- Good: import `terminal/` without implying fish; SSH or other shells work inside tmux
- Good: no TTY auto-tmux bootstrap in fish; Ghostty (or the user) starts tmux
- Bad: hosts need both `terminal/` and `shell/` for Alt+arrow pane keys with fish
