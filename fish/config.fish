set -gx EDITOR nvim

# Homebrew
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

# Java (Homebrew openjdk)
fish_add_path /opt/homebrew/opt/openjdk@21/bin
fish_add_path /opt/homebrew/opt/openjdk@17/bin

# Private env vars (tokens, passwords — not committed to dotfiles)
# ~/.env_vars.fish should use fish syntax:
#   set -gx GITHUB_TOKEN "..."
#   set -gx ARTY_USER "..."
if test -f ~/.env_vars.fish
    source ~/.env_vars.fish
end

# Zoxide
zoxide init fish | source
