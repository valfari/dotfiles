tt() {
btm --theme gruvbox --cpu-left-legend --group-processes
}
h() {
local num=${1:-10}
fc -l -r -$num
}
v() {
nvim "${1:-.}"
}

grh() {
if [ -z "$1" ]; then
git reset --hard
else
git reset --hard "$1"
fi
}

gpl() {
git pull
}
gps() {
git push
}
gpsf() {
git push --force
}
gb() {
git branch
}
guc() {
git reset HEAD~1 --soft
}
gl() {
local n=${1:-5}
git log | jc --git-log | jq 'reverse | map({commit, date, author, message: (.message | .[0:100])}) | .[0:'$n']'
}
v_nuke() {
if [ -z "$1" ]; then
echo "Missing substring argument for process killing"
return 1
fi
pkill -f "$1"
}
gc() {
if [ -z "$1" ]; then
echo "Missing branch argument"
return 1
fi
git checkout "$1"
}
gms() {
if [ -z "$1" ]; then
echo "Missing branch argument for git merge --squash"
return 1
fi
git merge --squash "$1"
}
gm() {
if [ -z "$1" ]; then
echo "Missing branch argument for git merge"
return 1
fi
git merge "$1"
}
gcam() {
if [ -z "$1" ]; then
echo "Missing message argument"
return 1
fi
git add .
git commit -am "$1"
}
gcb() {
if [ -z "$1" ]; then
echo "Missing branch argument"
return 1
fi
git checkout -b "$1"
}
gbd() {
if [ -z "$1" ]; then
echo "Missing branch argument"
return 1
fi
git branch -D "$1"
}

# eza
alias ls='eza'
alias ll='eza -l --git'
alias la='eza -la --git'
alias tree='eza --tree'
