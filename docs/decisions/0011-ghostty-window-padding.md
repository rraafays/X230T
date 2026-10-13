# Ghostty window padding

## Context and Problem Statement

Terminal content sat flush against the Ghostty window edge. Outer inset should come from the emulator, not tmux, so the full grid stays available inside tmux.

## Considered Options

- No padding (Ghostty defaults)
- `window-padding-x` / `window-padding-y` in Ghostty config with optional balance
- Fake padding via tmux status or border lines

## Decision Outcome

Chosen option: "`window-padding-x` / `window-padding-y` in Ghostty config with optional balance", because padding is visual margin outside the cell grid, scales with DPI, and applies to the whole session including tmux.

### Consequences

- Good, because readability improves without losing tmux rows or columns
- Good, because settings live in `terminal/default.nix` Ghostty block
- Bad, because padding changes apply to new Ghostty windows only
- Bad, because values are tuned by eye per font and display

Related commit: `973ae4e`.
