
# any cross machine environment config goes here

$env.EDITOR = "nvim"
$env.EZA_CONFIG_DIR = ($env.HOME | path join "Code/installs/dotfiles/eza")
$env.STARSHIP_CONFIG = ($env.HOME | path join "Code/installs/dotfiles/starship/starship.toml")
$env.ATUIN_CONFIG_DIR = ($env.HOME | path join "Code/installs/dotfiles/atuin")

# Homebrew
$env.PATH = ($env.PATH | prepend "/opt/homebrew/bin")
$env.PATH = ($env.PATH | prepend "/opt/homebrew/sbin")

# Java (Homebrew openjdk)
$env.PATH = ($env.PATH | prepend "/opt/homebrew/opt/openjdk@21/bin")
$env.PATH = ($env.PATH | prepend "/opt/homebrew/opt/openjdk@17/bin")

# Private env vars (tokens, passwords — not committed to dotfiles)
# ~/.env_vars.nu should mirror ~/.env_vars using nushell syntax:
#   $env.GITHUB_TOKEN = "..."
#   $env.ARTY_USER = "..."
#   etc.
if ($"($env.HOME)/.env_vars.nu" | path exists) {
    source ~/.env_vars.nu
}

# Note: sdkman does not support nushell. To use sdk commands, run them in a
# zsh subshell: ^zsh -c "source ~/.sdkman/bin/sdkman-init.sh && sdk <command>"
