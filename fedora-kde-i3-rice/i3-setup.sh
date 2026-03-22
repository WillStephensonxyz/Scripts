#!/bin/bash

# to do
# configure i3-status
# import programs from kde (kdewallet) or replace

packages=("i3" "i3status" "dmenu" "picom" "rxvt-unicode" "feh" "xmodmap")

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

IFS=, 
while read -r col1 col2; do
	echo "$col1" "$col2"
done < configs.csv

# Disable the beep
# rmmod pcspkr
# sudo echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

main() {
	# package_list
	# download config
	# keybinds
}

main

# echo "Packages and config files have been installed"
# echo "Reccomend rebooting the machine to load changes"
