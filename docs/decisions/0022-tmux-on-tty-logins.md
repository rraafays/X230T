# tmux on TTY logins

## Context and Problem Statement

Kitty starts tmux via `startup_session`; kmscon TTY logins only run fish. Without a bootstrap, virtual consoles would not get the same tmux-first workflow as the GUI terminal.

## Considered Options

- kmscon login script wrapping tmux
- Change login shell to a tmux wrapper for all sessions
- fish `conf.d` on local VT logins that `exec tmux` when `$TMUX` is unset

## Decision Outcome

Chosen option: "fish `conf.d` on local VT logins that `exec tmux` when `$TMUX` is unset", because it mirrors the GUI terminal’s `new-session -A -D -s ghostty`, skips SSH and GUI sessions, treats kmscon’s `/dev/pts/*` via `loginctl` session service, and lives in `terminal.nix` with the rest of the tmux stack.

### Consequences

- Good, because Ctrl+Alt+F* gets the same session name and attach behaviour as the GUI terminal when only one is in use
- Good, because GUI and TTY paths share one tmux config
- Bad, because GUI Kitty and a TTY can attach to the same `ghostty` session if both are active
- Bad, because rescue or non-fish login shells on a TTY bypass the bootstrap
