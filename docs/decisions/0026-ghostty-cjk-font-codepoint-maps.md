# Ghostty CJK font-codepoint maps

## Context and Problem Statement

Ghostty uses Iosevka only in `terminal/`. CJK in filenames and completion menus fell back through fontconfig to unpredictable faces (mixed region forms, uneven widths). We want Simplified Chinese glyph preference for Han while still using the correct Sarasa Gothic variant per script.

## Considered Options

- Repeated `font-family` fallback (`Iosevka` then `Sarasa Gothic SC`)
- `font-codepoint-map` for Han only, single Sarasa variant
- `font-codepoint-map` covering CJK blocks with SC for Han, J for kana, K for Hangul, TC for Bopomofo

## Decision Outcome

Chosen option: "`font-codepoint-map` covering CJK blocks with SC for Han, J for kana, K for Hangul, TC for Bopomofo", because it pins Unicode ranges to named Sarasa Gothic faces from `home.packages` without replacing Latin or Nerd glyphs in Iosevka, and matches Ghostty’s documented mechanism for locale-specific Han.

### Consequences

- Good, because Han and extensions render with Sarasa Gothic SC instead of ad hoc system CJK
- Good, because Japanese and Korean script ranges use J and K regardless of SC preference for ideographs
- Good, because config lives in `terminal/default.nix` next to font packages
- Bad, because Hangul Jamo Extended (U+A960–U+A97F) is omitted: Ghostty 1.3.1 rejects maps when Sarasa Gothic K has no glyphs for the range
- Bad, because new rare codepoints outside listed ranges still use system fallback until maps are extended
- Bad, because Ghostty applies map changes only to new tabs or windows after reload
