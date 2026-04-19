function gms --description 'Git merge --squash'
    if test -z "$argv[1]"
        echo "Missing branch argument"
        return 1
    end
    git merge --squash $argv[1]
end
