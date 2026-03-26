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

link_sway_host_config() {
    local sway_config_dir="$config/sway"
    local hostname
    local host_config

    if [ -r /etc/hostname ]; then
        hostname="$(tr -d '[:space:]' < /etc/hostname)"
    else
        hostname="$(hostname)"
    fi

    if [ "$hostname" = "desktop-tim" ]; then
        host_config="desktop.conf"
    else
        host_config="framework.conf"
    fi

    mkdir -p "$sway_config_dir"
    ln -sfn "$dotfiles/sway/$host_config" "$sway_config_dir/host.conf"
    echo -e "  ${green}Linked${reset} sway/$host_config -> $sway_config_dir/host.conf"
}

echo -e "${bold}Installing dotfiles from ${dotfiles}${reset}\n"

# Home directory dotfiles
link .vimrc "$HOME/.vimrc"
link .vimrc "$HOME/.ideavimrc"
link gitignore.dist "$HOME/.gitignore"
link gitconfig "$HOME/.gitconfig"

# .config directories — only linked if the program is installed
mkdir -p "$config"

link_if_installed i3       i3
link_if_installed i3status i3status
link_if_installed polybar  polybar
link_if_installed nvim     nvim
link_if_installed fish     fish

if command -v fish &>/dev/null; then
    echo -e "  ${green}Installing${reset} fish plugins (fisher update)"
    fish -c "fisher update" 2>/dev/null || true
fi
link_if_installed alacritty alacritty
link_if_installed sway     sway
if command -v sway &>/dev/null; then
    link_sway_host_config
fi
link_if_installed fuzzel   fuzzel
link_if_installed mako     mako
link_if_installed starship starship.toml
link_if_installed tmux     tmux
link_if_installed glow     glow

echo -e "\n${green}${bold}Done!${reset}"
