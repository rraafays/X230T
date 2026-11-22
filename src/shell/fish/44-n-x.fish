function n --description 'Run a command under nohup in the background'
    if test (count $argv) -eq 0
        echo 'n: missing command' >&2
        return 1
    end
    command nohup $argv &
    disown
end

function x --description 'Replace the shell with a command (exec)'
    if test (count $argv) -eq 0
        echo 'x: missing command' >&2
        return 1
    end
    exec $argv
end
