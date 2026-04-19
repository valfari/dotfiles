function gm --description 'Git merge'
    if test -z "$argv[1]"
        echo "Missing branch argument"
        return 1
    end
    git merge $argv[1]
end
