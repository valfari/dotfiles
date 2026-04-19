function fish_prompt
    set -l last_status $status

    set_color '#7aa2f7'
    echo -n (prompt_pwd)
    set_color normal

    # Git branch
    set -l branch (git branch --show-current 2>/dev/null)
    if test -n "$branch"
        set_color '#565f89'
        echo -n '  '
        set_color '#bb9af7'
        echo -n $branch
        set_color normal
    end

    # Prompt char — green on success, red on error
    echo -n ' '
    if test $last_status -eq 0
        set_color '#9ece6a'
    else
        set_color '#f7768e'
    end
    echo -n '❯ '
    set_color normal
end
