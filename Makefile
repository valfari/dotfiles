DOTFILES := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
CONFIG   := $(HOME)/.config

.DEFAULT_GOAL := help

.PHONY: help install uninstall nvim fish nushell wezterm git bottom htop scooter atuin starship eza

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "  install     Symlink all configs into ~/.config"
	@echo "  uninstall   Remove all managed symlinks"
	@echo ""
	@echo "  Individual: nvim fish nushell wezterm git bottom htop scooter atuin starship eza"

install: nvim fish nushell wezterm git bottom htop scooter atuin starship eza

# --- whole-directory symlinks ---

nvim:
	ln -sfn $(DOTFILES)/nvim $(CONFIG)/nvim
	@echo "  nvim"

wezterm:
	ln -sfn $(DOTFILES)/wezterm $(CONFIG)/wezterm
	@echo "  wezterm"

scooter:
	ln -sfn $(DOTFILES)/scooter $(CONFIG)/scooter
	@echo "  scooter"

nushell:
	ln -sfn $(DOTFILES)/nushell $(CONFIG)/nushell
	@echo "  nushell"

atuin:
	ln -sfn $(DOTFILES)/atuin $(CONFIG)/atuin
	@echo "  atuin"

eza:
	ln -sfn $(DOTFILES)/eza $(CONFIG)/eza
	@echo "  eza"

# --- fish: real dir managed by fish, symlink individual items ---
# (~/.config/fish/fish_variables is written by fish itself, not ours)

fish:
	@mkdir -p $(CONFIG)/fish/conf.d
	ln -sfn $(DOTFILES)/fish/functions   $(CONFIG)/fish/functions
	rm -rf  $(CONFIG)/fish/completions
	ln -sfn $(DOTFILES)/fish/completions $(CONFIG)/fish/completions
	ln -sf  $(DOTFILES)/fish/config.fish $(CONFIG)/fish/config.fish
	ln -sf  $(DOTFILES)/fish/conf.d/aliases.fish $(CONFIG)/fish/conf.d/aliases.fish
	@echo "  fish"

# --- individual file symlinks ---

git:
	@mkdir -p $(CONFIG)/git
	ln -sf $(DOTFILES)/git/config $(CONFIG)/git/config
	ln -sf $(DOTFILES)/git/ignore $(CONFIG)/git/ignore
	@echo "  git"

bottom:
	@mkdir -p $(CONFIG)/bottom
	ln -sf $(DOTFILES)/bottom/bottom.toml $(CONFIG)/bottom/bottom.toml
	@echo "  bottom"

htop:
	@mkdir -p $(CONFIG)/htop
	ln -sf $(DOTFILES)/htop/htoprc $(CONFIG)/htop/htoprc
	@echo "  htop"

starship:
	ln -sf $(DOTFILES)/starship/starship.toml $(CONFIG)/starship.toml
	@echo "  starship"

# --- uninstall ---

uninstall:
	rm -f  $(CONFIG)/nvim
	rm -f  $(CONFIG)/wezterm
	rm -f  $(CONFIG)/scooter
	rm -f  $(CONFIG)/nushell
	rm -f  $(CONFIG)/atuin
	rm -f  $(CONFIG)/eza
	rm -f  $(CONFIG)/fish/functions
	rm -f  $(CONFIG)/fish/completions
	rm -f  $(CONFIG)/fish/config.fish
	rm -f  $(CONFIG)/fish/conf.d/aliases.fish
	rm -f  $(CONFIG)/git/config
	rm -f  $(CONFIG)/git/ignore
	rm -f  $(CONFIG)/bottom/bottom.toml
	rm -f  $(CONFIG)/htop/htoprc
	rm -f  $(CONFIG)/starship.toml
	@echo "Symlinks removed"
