function gcam --description 'Git add all and commit'
    if test -z "$argv[1]"
        echo "Missing commit message argument"
        return 1
    end
    git add .
    git commit -am $argv[1]
end
