# Alacritty instead of Kitty

## Context and Problem Statement

The GUI terminal was Kitty with `adwaita_dark`, store-path Iosevka faces, and a long CJK `symbol_map` list. We want a leaner emulator on GNOME with the same Adwaita Dark look, tmux session `ghostty`, and Iosevka with Sarasa for CJK via Fontconfig instead of emulator-specific maps.

## Considered Options

- Keep Kitty with `symbol_map` and `startup_session`
- GNOME Terminal with profile font and Fontconfig fallbacks
- Alacritty with embedded Adwaita Dark colours, `shell` tmux attach, and Fontconfig `monospace` prefer

## Decision Outcome

Chosen option: "Alacritty with embedded Adwaita Dark colours, `shell` tmux attach, and Fontconfig `monospace` prefer", because Home Manager `programs.alacritty` is declarative, tmux-first behaviour matches prior emulators, and Fontconfig Iosevka → Sarasa Mono SC avoids maintaining per-range maps without losing sensible CJK fallback on Linux.

### Consequences

- Good, because tmux config and session name are unchanged
- Good, because Adwaita Dark matches the GNOME / libadwaita desktop palette
- Good, because font policy lives in one Fontconfig snippet plus a single primary family
- Bad, because CJK glyph choice is coarser than Kitty or Ghostty codepoint maps
- Bad, because ADR 0027 described Kitty; 0028 supersedes the GUI emulator choice
