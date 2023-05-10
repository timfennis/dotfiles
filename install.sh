#!/bin/sh
set -e

cd "$HOME"

ln -sf .dotfiles/.zshrc .zshrc
ln -sf .dotfiles/.vimrc .vimrc
ln -sf .dotfiles/.vimrc .ideavimrc

