function v_nuke --description 'Kill processes matching a substring'
    if test -z "$argv[1]"
        echo "Missing substring argument for process killing"
        return 1
    end
    pkill -f $argv[1]
end
