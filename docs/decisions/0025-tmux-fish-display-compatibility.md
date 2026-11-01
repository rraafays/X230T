# Tmux and fish display compatibility

## Context and Problem Statement

Tab completion in fish over SSH inside a local tmux split (for example btop in one pane, `ssh SRVR` in another) drew completion columns padded to the wrong width and could corrupt the tmux display across pane borders. Fish and starship layout use `$COLUMNS`; that variable often reflects the client window or an old size, not the SSH PTY width inside the tmux pane.

## Considered Options

- Fish feature flags and prompt-marking disables in tmux
- Keep `$COLUMNS` in sync with `stty size` before completion; stop sshd from accepting client `COLUMNS`/`LINES`
- Disable fish tab completion in tmux

## Decision Outcome

Chosen option: sync `$COLUMNS`/`$LINES` with the PTY and restrict `AcceptEnv`, because fish upstream tests assume `$COLUMNS` matches the tmux pane and OpenSSH should not inject a conflicting width from the client.

### Consequences

- Good: `shell/46-pty-term-size.fish` and shared `system/services.nix` apply on X230T and SRVR via submodules
- Good: no `fish_features` toggles; `terminal/` stays shell-agnostic
- Bad: tab binding is overridden in insert mode when `$TMUX` or `$SSH_CONNECTION` (vi bindings only)
