set -g fish_greeting ""

set -gx EDITOR nvim
set -gx MANPAGER 'nvim +Man!'
set -gx STARSHIP_CONFIG ~/Code/installs/dotfiles/starship/starship.toml
set -gx ATUIN_CONFIG_DIR ~/Code/installs/dotfiles/atuin

# Homebrew
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

# Coursier (Scala tooling: metals, bloop, cs)
fish_add_path "/Users/vustimenko/Library/Application Support/Coursier/bin"

# uv tools (serena, etc.)
fish_add_path ~/.local/bin

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

# WezTerm: report cwd changes via OSC 7 so pane:get_current_working_dir() stays current
function __wezterm_osc7 --on-variable PWD
    if status is-interactive
        printf "\e]7;file://%s%s\a" (hostname) (pwd | string escape --style url)
    end
end

# Starship prompt
starship init fish | source

# Atuin (shell history — replaces Ctrl+R)
atuin init fish | source
