function v --description 'Open nvim (defaults to current directory)'
    if test -n "$argv[1]"
        nvim $argv[1]
    else
        nvim .
    end
end
