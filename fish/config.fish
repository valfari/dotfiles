set -g fish_greeting ""

set -gx EDITOR nvim
set -gx MANPAGER 'nvim +Man!'

# Homebrew
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

# Java (Homebrew openjdk)
fish_add_path /opt/homebrew/opt/openjdk@21/bin
fish_add_path /opt/homebrew/opt/openjdk@17/bin
set -gx JAVA_HOME /opt/homebrew/opt/openjdk@21

# Private env vars (tokens, passwords — not committed to dotfiles)
# ~/.env_vars.fish should use fish syntax:
#   set -gx GITHUB_TOKEN "..."
#   set -gx ARTY_USER "..."
if test -f ~/.env_vars.fish
    source ~/.env_vars.fish
end

# Zoxide
zoxide init fish | source

# fzf shell keybindings (Ctrl+R history, Ctrl+T file insert)
if command -q fzf
    fzf --fish | source
end

# direnv
if command -q direnv
    direnv hook fish | source
end
