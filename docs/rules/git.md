# Git and agents

Humans own every commit. Automation (including Cursor agents) may use git to inspect and prepare work, but must not create commits.

## Allowed without asking

Typical read and sync commands, for example:

- `git status`, `git diff`, `git log`, `git show`
- `git fetch`, `git pull` (when needed to answer a task)
- `git submodule update --init --recursive`
- `git add`, `git restore`, `git checkout` when preparing or reverting files for the user’s review

Use these to understand state, verify builds, or leave changes staged/unstaged as the user prefers.

## Never without explicit user request

- **`git commit`** (including empty commits, `--amend`, and commits inside submodules)
- **`git push`** (and force-push)
- History rewrite: **`git rebase`**, **`git reset`**, **`git cherry-pick`** that lands commits, and other destructive history edits

When a task is done, describe what changed and suggest a commit message; the user commits.

## Submodule workflow

Module changes still happen in `src/<name>` repos, but **commits and pushes to module remotes are human steps** unless the user asks the agent to commit in that message.

See [submodules.md](submodules.md) for clone and bump flow.
