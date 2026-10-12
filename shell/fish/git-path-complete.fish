set -g __git_path_complete_cmds \
    nvim vim vi \
    bat cat less more head tail \
    rm cp mv ln \
    chmod chown \
    nano \
    jq yq \
    diff patch

function __git_paths_in_repo
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
end

function __git_paths_refresh --on-event fish_prompt
    if not __git_paths_in_repo
        set -e __git_paths_items
        return
    end

    set -l root (git rev-parse --show-toplevel)
    set -l cwd (pwd -P)
    set -l items

    for line in (git status --porcelain=1 2>/dev/null)
        test -n "$line"
        or continue

        set -l xy (string sub -s 1 -l 2 $line)
        set -l path (string trim (string sub -s 4 $line))
        if string match -qr ' -> ' -- $path
            set path (string replace -r '^.* -> ' '' $path)
        end

        set -l full "$root/$path"
        test -e $full
        or continue

        set -l cand (realpath --relative-to=$cwd $full 2>/dev/null)
        if test -z "$cand"
            set cand $path
        end

        set -a items (printf '%s\t%s' $cand $xy)
    end

    set -g __git_paths_items $items
end

function __git_completion_paths
    set -q __git_paths_items
    or return
    printf '%s\n' $__git_paths_items
end

function __fish_git_paths_should_complete
    __git_paths_in_repo
end

for c in $__git_path_complete_cmds
    complete --keep-order -c $c \
        -n __fish_git_paths_should_complete \
        -a '(__git_completion_paths)'
end
