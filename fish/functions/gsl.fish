function gsl --description 'Git stat lines vs ref (default HEAD)'
    set -l ref HEAD
    set -l detailed false

    for arg in $argv
        switch $arg
            case -d --detailed
                set detailed true
            case '*'
                set ref $arg
        end
    end

    if test $detailed = true
        git diff --stat $ref
    else
        set -l stats (git diff --shortstat $ref)
        set -l added (echo $stats | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+')
        set -l deleted (echo $stats | grep -oE '[0-9]+ deletion' | grep -oE '[0-9]+')
        test -z "$added" && set added 0
        test -z "$deleted" && set deleted 0
        echo "+$added  -$deleted  (vs $ref)"
    end
end
