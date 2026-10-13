# Git submodules under src/

## Context and Problem Statement

Nix modules lived as top-level directories in the X230T host repo. Reuse and independent versioning were harder; the user wanted each module in its own repository while keeping the laptop host repo focused on machine imports and settings.

## Considered Options

- Monorepo only (status quo)
- Git submodules at repo root (`./shell`, …)
- Git submodules under `src/<name>/` pointing at `rraafays/<name>.nix` repos

## Decision Outcome

Chosen option: "Git submodules under `src/<name>/` pointing at `rraafays/<name>.nix` repos", because the host tree stays small (`configuration.nix`, hardware, docs), module repos match directory names with a `.nix` suffix, and fresh initial commits per module avoid a heavy history split.

### Consequences

- Good, because each module can be cloned, branched, and released on its own GitHub repo
- Good, because `configuration.nix` imports stay explicit (`./src/shell`, …)
- Bad, because clones need `--recurse-submodules` or `submodule update --init`
- Bad, because formatting and edits may require commits in a submodule before bumping the host pointer
