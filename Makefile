DOTFILES := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
CONFIG   := $(HOME)/.config

.DEFAULT_GOAL := help

.PHONY: help install uninstall nvim fish nushell wezterm git bottom htop scooter

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "  install     Symlink all configs into ~/.config"
	@echo "  uninstall   Remove all managed symlinks"
	@echo ""
	@echo "  Individual: nvim fish nushell wezterm git bottom htop scooter"

install: nvim fish nushell wezterm git bottom htop scooter

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

# --- fish: real dir managed by fish, symlink individual items ---
# (~/.config/fish/fish_variables is written by fish itself, not ours)

fish:
	@mkdir -p $(CONFIG)/fish/conf.d
	ln -sfn $(DOTFILES)/fish/functions  $(CONFIG)/fish/functions
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

# --- uninstall ---

uninstall:
	rm -f  $(CONFIG)/nvim
	rm -f  $(CONFIG)/wezterm
	rm -f  $(CONFIG)/scooter
	rm -f  $(CONFIG)/nushell
	rm -f  $(CONFIG)/fish/functions
	rm -f  $(CONFIG)/fish/config.fish
	rm -f  $(CONFIG)/fish/conf.d/aliases.fish
	rm -f  $(CONFIG)/git/config
	rm -f  $(CONFIG)/git/ignore
	rm -f  $(CONFIG)/bottom/bottom.toml
	rm -f  $(CONFIG)/htop/htoprc
	@echo "Symlinks removed"
