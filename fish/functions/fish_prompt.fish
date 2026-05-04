function fish_prompt
    set -l last_status $status

    set_color blue
    echo -n (prompt_pwd)
    set_color normal

    set -l branch (git branch --show-current 2>/dev/null)
    if test -n "$branch"
        set_color brblack
        echo -n '  '
        set_color magenta
        echo -n $branch
        set_color normal
    end

    if test -n "$VIRTUAL_ENV"
        set_color brblack
        echo -n '  '
        set_color yellow
        echo -n (basename $VIRTUAL_ENV)
        set_color normal
    end

    echo -n ' '
    if test $last_status -eq 0
        set_color green
    else
        set_color red
    end
    echo -n '❯ '
    set_color normal
end
