function gbd --description 'Git branch -D (force delete branch)'
    if test -z "$argv[1]"
        echo "Missing branch argument"
        return 1
    end
    git branch -D $argv[1]
end
