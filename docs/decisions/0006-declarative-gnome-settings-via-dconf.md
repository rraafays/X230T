# Declarative GNOME settings via dconf

## Context and Problem Statement

GNOME preferences were only in the live dconf database. Rebuilds did not reproduce desktop settings, and there was no reviewed file for shell extensions, mouse speed, or similar keys.

## Considered Options

- Manual dconf only after install
- Home Manager activation running `dconf load` from a tracked `settings.ini`
- GNOME settings purely via NixOS `services.xserver.desktopManager.gnome` options only

## Decision Outcome

Chosen option: "Home Manager activation running `dconf load` from a tracked `settings.ini`", because most tuned keys already exist as a dump format, fit under `user/dconf/`, and apply on each Home Manager activation after rebuild.

### Consequences

- Good, because desktop settings are versioned with the repo
- Good, because `user/dconf/README.md` documents merge workflow from live session
- Bad, because dumps can include stale paths or machine-specific extension state
- Bad, because invalid dconf syntax fails activation until the ini is fixed

Related commit: `a0fd2bb`.
