def tt [] {btm --theme gruvbox --cpu-left-legend --group-processes}
def h [$num?] { 
	if ($num | is-empty) {
		history | reverse | take 10
	} else {
		history | reverse | take $num
	}
}

def q [] {
	kscreen-doctor $"output.1.brightness.0.1"
	nvim --help
}

def v [$directory?] {
	if ($directory | is-empty) {
		nvim .
	} else {
		nvim $directory
	}
}

def vc [] {do {cd ~/.config/dotfiles; nvim ~/.config/dotfiles}}

def grh [branch?: string@git_reset_hard_completer] {
	if ($branch | is-empty) {
		git reset --hard
	} else {
		git reset --hard $branch
	}
}

def gpl [] {git pull}

def gps [] {git push}

def gpsf [] {git push --force}

def gb [] {git branch}

def guc [] {git reset HEAD~1 --soft}

def gl [$n?: int] {
    if ($n| is-empty) {
	git log | jc --git-log | from json | select commit date author message | reverse | update message { |row| $row.message | str substring 0..100 } | take 5
    }
	git log | jc --git-log | from json | select commit date author message | reverse | update message { |row| $row.message | str substring 0..100 } | take $n
}

def v_nuke [substring?: string] {
	if ($substring | is-empty) {
	print "Missing substring argument for process killing"
	return 1
	}
	^pkill -f $substring
}

def gc [branch?: string@git_checkout_completer] {
    if ($branch | is-empty) {
        print "Missing branch argument"
        return 1
    }
    ^git checkout $branch
}

def gms [branch?: string@git_merge_squash_completer] {
	if ($branch | is-empty) {
	print "Missing branch argument for git merge --rebase"
	return 1
	}
	^git merge --squash $branch
}

def gm [branch?: string@git_merge_completer] {
	if ($branch | is-empty) {
	print "Missing branch argument for git merge --rebase"
	return 1
	}
	^git merge $branch
}

def gcam [message?: string] {
	if ($message | is-empty) {
	print "Missing message argument"
	return 1
	}
	^git add .
	^git commit -am $message
}

def gcb [branch?: string] {
	if ($branch | is-empty) {
	print "Missing branch argument"
	return 1
	}
	^git checkout -b $branch
}

def gbd [branch?: string@git_branch_delete_completer] {
	if ($branch | is-empty) {
	print "Missing branch argument"
	return 1
	}
	^git branch -D $branch
}

# eza
alias ls   = eza
alias ll   = eza -l --git
alias la   = eza -la --git
alias tree = eza --tree
