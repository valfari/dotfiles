function clav --description 'Compose a Claude prompt in nvim, then run claude'
    set -l tmpfile (mktemp /tmp/claude_prompt_XXXXXX.md)
    nvim $tmpfile
    if test -s $tmpfile
        cat $tmpfile | command claude $argv
    end
    rm -f $tmpfile
end
