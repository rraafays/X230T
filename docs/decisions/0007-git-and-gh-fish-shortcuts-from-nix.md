# Git and gh fish shortcuts generated from Nix

## Context and Problem Statement

Fish needed short git and GitHub CLI commands without reserving common names (e.g. `rm` for the shell). Shortcuts should stay in sync with installed `git` and `gh` subcommands.

## Considered Options

- Hand-written fish functions in static files
- Nix-generated fish snippets from `git`/`gh` help at build time
- External fish plugin framework

## Decision Outcome

Chosen option: "Nix-generated fish snippets from `git`/`gh` help at build time", because `shell/fish/git-gh-fish.nix` can regenerate completions when packages update, and Nix can exclude names like `rm` while exposing `rmv` for `git rm`.

### Consequences

- Good, because alias set tracks the packaged CLI surface
- Good, because build-time generation avoids drift from hand-maintained lists
- Bad, because generation logic is custom and must be read to change behaviour
- Bad, because rebuild is required for shortcut changes

Related commits: `5cb9b69`, `b6a7fd8`.
