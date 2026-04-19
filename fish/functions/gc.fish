function gc --description 'Git checkout'
    if test -z "$argv[1]"
        echo "Missing branch argument"
        return 1
    end
    git checkout $argv[1]
end
