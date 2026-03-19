#!/bin/bash

# to do
# configure i3-status
# import programs from kde (kdewallet) or replace
# refactor config downloads - turn into a case statement that checks, downloads config & mv to path
# create preferred optional file structure

packages=("i3" "i3status" "dmenu" "picom" "rxvt-unicode" "feh" "xmodmap")

i3_config="https://raw.githubusercontent.com/WillStephensonxyz/dotfiles/refs/heads/main/i3-laptop-rice/i3-kde/config"
xresources_config="https://raw.githubusercontent.com/WillStephensonxyz/dotfiles/refs/heads/main/i3-laptop-rice/i3-Xresources/.Xresources"
picom_config="https://raw.githubusercontent.com/WillStephensonxyz/dotfiles/refs/heads/main/i3-laptop-rice/i3-picom/picom.conf"

i3_path="$HOME/.config/i3/config"
xresources_path="$HOME/.Xresources"
picom_path="$HOME/.config/picom/picom.conf"
kaccessrc="$HOME/.config/kaccessrc"
xmodmap="$HOME/.Xmodmap"

package_list() {
	echo "[*] Checking packages"
	
	for package in ${packages[@]}; do
		rpm -q "$package" 2>/dev/null 2>&1 || {
			echo "Installing "$package""
			sudo dnf install "$package"
		}
	done
}

download_config() {
	local config_file=="$1"
	local download_url=="$2"

	[[ ! -f "$config_file" ]] && mkdir -p "$(dirname $config_file)" 
	wget "$download_url" -O "$config_file" 
}

keybinds() {
	local line="keycode 107 = Super_L"
	local xmodmap="$HOME/.Xmodmap"

	[[ -f "$xmodmap" ]] || touch "$xmodmap"
	grep -q "$line" "$xmodmap" || echo "$line" >> "$xmodmap"
	xmodmap "$xmodmap" 
}

# Optional directories
[[ -d "$HOME"/Projects ]] || mkdir "$HOME/Projects"
[[ -d "$HOME"/Study ]] || mkdir "$HOME/Study"

# Disable the beep
rmmod pcspkr
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

main() {
	# package_list
	# download config
	keybinds
	
}

main

# echo "Packages and config files have been installed"
# echo "Reccomend rebooting the machine to load changes"
