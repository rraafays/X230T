# Kitty instead of Ghostty

## Context and Problem Statement

The GUI terminal was Ghostty with `font-codepoint-map`, window padding, and a systemd user service. A brief GNOME Terminal experiment was reverted. We want Kitty on GNOME Wayland with Adwaita Dark colours, client-side window decorations, and the same tmux-first session and CJK font routing.

## Considered Options

- Restore Ghostty with maps and padding
- GNOME Terminal with Fontconfig fallbacks (reverted)
- Kitty with `adwaita_dark`, `symbol_map`, `startup_session`, and Wayland client decorations

## Decision Outcome

Chosen option: "Kitty with `adwaita_dark`, `symbol_map`, `startup_session`, and Wayland client decorations", because Kitty supports per-codepoint fonts like Ghostty, runs well on GNOME Wayland with its own CSD (`hide_window_decorations no`), and stays declarative via Home Manager `programs.kitty`.

### Consequences

- Good, because tmux session `ghostty` and tmux config are unchanged
- Good, because CJK ranges stay explicit via `symbol_map` in `terminal/default.nix`
- Good, because `themeFile = adwaita_dark` matches the GNOME dark desktop stack
- Bad, because Kitty CSD on GNOME may not match libadwaita chrome pixel-perfect
- Bad, because ADRs 0010, 0011, and 0026 describe Ghostty; 0027 supersedes the GUI emulator choice for new work
