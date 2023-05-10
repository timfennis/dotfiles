#!/bin/sh
set -e

cd "$HOME"

ln -sf ~/.dotfiles/.zshrc .zshrc
ln -sf ~/.dotfiles/.vimrc .vimrc
ln -sf ~/.dotfiles/.vimrc .ideavimrc
mkdir -p .config/i3/ && \
    ln -sf ~/.dotfiles/i3/config .config/i3/config

