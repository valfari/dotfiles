# config.nu
#
# Installed by:
# version = "0.106.1"

$env.config.buffer_editor = "nvim"

const modules_path = $nu.config-path | path dirname | path join modules

source ($modules_path)/env_conf.nu
source ($modules_path)/completion.nu
source ($modules_path)/aliases.nu
source ~/.zoxide.nu

# Starship prompt
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
source ~/.cache/starship/init.nu

# Atuin (shell history — replaces Ctrl+R)
mkdir ~/.local/share/atuin
atuin init nu | save -f ~/.local/share/atuin/init.nu
source ~/.local/share/atuin/init.nu
