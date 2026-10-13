# Desktop module owns GNOME dconf

## Context and Problem Statement

GNOME `settings.ini` and Home Manager `dconf load` activation lived under `user/` while `desktop/` already owned the GNOME session and GTK/Qt theming. That split forced importers of `./desktop` to also import `./user` for declarative GNOME prefs, against the out-of-the-box module policy in ADR 0017.

## Considered Options

- Keep dconf under `user/` and document the coupling
- Move `dconf/` and HM activation into `desktop/`
- Drive all GNOME keys only via NixOS GNOME options

## Decision Outcome

Chosen option: "Move `dconf/` and HM activation into `desktop/`", because `./desktop` should deliver GNOME desktop behaviour including versioned dconf; `user/` stays account, packages, git, and `gh`.

### Consequences

- Good, because headless or minimal hosts can omit `user/` but still use `desktop/` with a minimal `users.users` stub if needed
- Good, because README scope matches where files live
- Bad, because ADR 0006 and old docs still mention `user/dconf/` historically
- Bad, because app packages remain in `user/` while dconf keys for those apps are edited under `desktop/dconf/`
