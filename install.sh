#!/bin/bash
set -euo pipefail

green="\e[1;32m"
yellow="\e[1;33m"
bold="\e[1m"
reset="\e[0m"

dotfiles="$HOME/.dotfiles"
config="$HOME/.config"

link() {
    local src="$dotfiles/$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        return
    fi

    ln -sfn "$src" "$dest"
    echo -e "  ${green}Linked${reset} $1 -> $dest"
}

link_if_installed() {
    local cmd="$1"
    local dir="$2"

    if ! command -v "$cmd" &>/dev/null; then
        echo -e "  ${yellow}Skipped${reset} $dir ($cmd not found)"
        return
    fi

    link "$dir" "$config/$dir"
}

echo -e "${bold}Installing dotfiles from ${dotfiles}${reset}\n"

# Home directory dotfiles
link .vimrc "$HOME/.vimrc"
link .vimrc "$HOME/.ideavimrc"
link gitignore.dist "$HOME/.gitignore"

# .config directories — only linked if the program is installed
mkdir -p "$config"

link_if_installed i3       i3
link_if_installed i3status i3status
link_if_installed polybar  polybar
link_if_installed nvim     nvim
link_if_installed fish     fish
link_if_installed alacritty alacritty
link_if_installed sway     sway
link_if_installed fuzzel   fuzzel
link_if_installed mako     mako
link_if_installed starship starship.toml
link_if_installed tmux     tmux

echo -e "\n${green}${bold}Done!${reset}"
