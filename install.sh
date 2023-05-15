#!/bin/sh
set -e

cd "$HOME"

ln -sf ~/.dotfiles/.zshrc .zshrc
ln -sf ~/.dotfiles/.vimrc .vimrc
ln -sf ~/.dotfiles/.vimrc .ideavimrc
ln -sf ~/.dotfiles/.Xresources .Xresources

ln -sf ~/.dotfiles/i3/ .config/
ln -sf ~/.dotfiles/alacritty/ .config/
ln -sf ~/.dotfiles/polybar/ .config/
ln -sf ~/.dotfiles/nvim/ .config/
