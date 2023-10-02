#!/bin/sh
set -e

# ANSI escape sequences for text formatting
green_bold="\e[1;32m"
red_bold="\e[1;31m"
bold="\e[1m"
reset="\e[0m"

# Switch to our user's $HOME directory as a base for creating the various symlinks
echo -e "Switching to ${bold}${HOME}${reset}."
cd "$HOME"

# Symlink some config files that just live directly inside our home directory
ln -sf ~/.dotfiles/.zshrc .zshrc
ln -sf ~/.dotfiles/.vimrc .vimrc
ln -sf ~/.dotfiles/.vimrc .ideavimrc
ln -sf ~/.dotfiles/.Xresources .Xresources

# Programs that use a directory inside .config are linked a directory usually because
# their configuration requires multiple files
mkdir -p .config/
ln -sf ~/.dotfiles/i3/ .config/
ln -sf ~/.dotfiles/polybar/ .config/
ln -sf ~/.dotfiles/nvim/ .config/
ln -sf ~/.dotfiles/fish/ .config/

ln -sf ~/.dotfiles/alacritty/ .config/
