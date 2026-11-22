if not status is-interactive
    return
end

function __fish_sync_term_env_to_pty
    set -l dim (command stty size 2>/dev/null | string split ' ')
    test (count $dim) -eq 2; or return
    set -gx LINES $dim[1]
    set -gx COLUMNS $dim[2]
end

function __fish_sync_term_env_to_pty_winch --on-signal WINCH
    __fish_sync_term_env_to_pty
end

function __fish_tab_complete_with_pty_width
    __fish_sync_term_env_to_pty
    commandline -f complete
end

__fish_sync_term_env_to_pty

if set -q TMUX; or set -q SSH_CONNECTION
    bind --preset -M insert \t __fish_tab_complete_with_pty_width
end
