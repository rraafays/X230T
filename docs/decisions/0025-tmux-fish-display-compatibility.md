# Tmux and fish display compatibility

## Context and Problem Statement

Tmux with fish and vi bindings showed broken completions and pane redraw glitches. Fish-specific tmux snippets did not belong in the shell-agnostic `terminal/` module.

## Considered Options

- More fish workarounds in `terminal/` (focus events, ambiguous width, repaint hooks)
- Split responsibilities: `terminal/` only Ghostty + tmux; `shell/` owns optional fish/tmux key passthrough
- Drop tmux

## Decision Outcome

Chosen option: "Split responsibilities", with tmux term settings in `terminal/` and fish tmux snippets in `shell/` (`46-tmux`, `55-tmux-alt-keys`).

### Consequences

- Good: import `terminal/` without implying fish; SSH or other shells work inside tmux
- Good: `46-tmux` disables fish prompt OSC marking and terminal queries in tmux so completions and SSH splits do not corrupt other panes
- Bad: hosts need `shell/` for fish tmux fixes even when only the remote side runs fish over SSH
