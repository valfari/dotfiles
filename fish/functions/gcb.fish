function gcb --description 'Git checkout -b (create new branch)'
    if test -z "$argv[1]"
        echo "Missing branch argument"
        return 1
    end
    git checkout -b $argv[1]
end
