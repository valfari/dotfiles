function h --description 'Show recent history (default 10)'
    if test -n "$argv[1]"
        history | head -n $argv[1]
    else
        history | head -n 10
    end
end
