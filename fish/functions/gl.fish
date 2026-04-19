function gl --description 'Pretty git log (default 5 entries)'
    set -l n 5
    if test -n "$argv[1]"
        set n $argv[1]
    end
    git log --pretty=format:"%C(yellow)%h%Creset  %C(cyan)%ad%Creset  %C(green)%an%Creset  %<(100,trunc)%s" --date=short | head -n $n
end
