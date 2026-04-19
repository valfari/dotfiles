function grh --description 'Git reset --hard (optionally to a ref)'
    if test -n "$argv[1]"
        git reset --hard $argv[1]
    else
        git reset --hard
    end
end
