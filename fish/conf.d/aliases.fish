set -gx EZA_CONFIG_DIR ~/Code/installs/dotfiles/eza

# Git abbreviations (expand in-place before execution)
abbr -a gs git status
abbr -a gpl git pull
abbr -a gps git push
abbr -a gpsf git push --force
abbr -a gb git branch
abbr -a guc git reset HEAD~1 --soft

# Shell abbreviations
abbr -a cl clear
abbr -a c clear
abbr -a ee exit

# eza
abbr -a ls eza
abbr -a ll 'eza -l --git'
abbr -a la 'eza -la --git'
abbr -a tree 'eza --tree'
