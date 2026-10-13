# Ghostty and tmux terminal stack

## Context and Problem Statement

The interactive terminal should be a modern emulator that launches tmux by default, with fish and editor integration aware of tmux panes.

## Considered Options

- Terminal emulator only, no tmux by default
- Ghostty (or similar) with default command starting or attaching tmux
- Tmux-only in a generic xterm without dedicated emulator config

## Decision Outcome

Chosen option: "Ghostty with default command starting or attaching tmux", because Ghostty handles GUI theming and fonts while tmux owns splits and session persistence; Neovim can expose tmux-aware navigation via `editor/lua/editor/tmux.lua`.

### Consequences

- Good, because one Ghostty window maps to a tmux session (`ghostty`)
- Good, because terminal config is isolated in `terminal/` Home Manager module
- Bad, because debugging requires both emulator and tmux layers
- Bad, because non-tmux workflows need overriding Ghostty `command`

Related commit: `5161869` (tmux integration); base module from `c7b53a5`.
