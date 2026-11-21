# GNOME light default theming

## Context and Problem Statement

The desktop module forced Adwaita Dark for GTK (`gtk.theme`, `colorScheme`) and Qt (`adwaita-dark` style). That fought default GNOME and most applications and websites, which assume light/default styling. Light mode feels more productive and keeps GTK, Qt, and web content visually consistent without per-app dark overrides.

## Considered Options

- Keep declarative Adwaita Dark for GTK and Qt in `desktop/`
- GNOME defaults for GTK/Shell only; Qt via `platformTheme.name = adwaita` and `style.name = adwaita`
- GNOME defaults for GTK; Qt fixed to Adwaita light without GNOME platform integration

## Decision Outcome

Chosen option: "GNOME defaults for GTK/Shell only; Qt via `platformTheme.name = adwaita` and `style.name = adwaita`", because GTK and Shell theming stay in GNOME Settings (default light), Qt apps use Adwaita light consistently, and Nix no longer pins dark GTK/Qt. Home Manager requires `style.name` alongside the platform theme.

### Consequences

- Good, because light GNOME matches typical app and site defaults
- Good, because fewer HM `gtk`/`qt.style` knobs and less drift from upstream GNOME
- Bad, because terminal palette (Alacritty) and other modules may still be dark until changed separately
- Bad, because Qt appearance depends on portal/GNOME; explicit `adwaita` light is the fallback if follow breaks