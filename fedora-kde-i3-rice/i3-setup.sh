#!/bin/bash
set -euo pipefail

# to do
# configure i3-status
# delete native kde wallet program and replace with something else

packages=("i3" "i3status" "dmenu" "picom" "rxvt-unicode" "feh" "xmodmap")

xmodmap="$HOME/.Xmodmap"

download_packages() {
	for package in ${packages[@]}; do
		rpm -q "$package" &>/dev/null || {
			echo "Installing "$package""
			sudo dnf install -y "$package"
		}
	done
}

# Download config files from github repo
download_config() {
	local config_file="$HOME/$1"
	local url="$2"

	[[ -f "$config_file" ]] && return 

	mkdir -p "$(dirname "$config_file")" 
	wget "$url" -O "$config_file" 
}

# Parses configs csv file and downloads config files
apply_configs () {
	while IFS=, read -r col1 col2; do
		download_config "$col1" "$col2"
	done < configs.csv
}

software() {
	echo "[*] Checking packages"
	download_packages
	echo "[*] Applying configs" 
	apply_configs
}

software

# Remap PrtScr to Mod key
[[ -f "$HOME/.Xmodmap" ]] || touch "$HOME/.Xmodmap"
grep -qf "keycode 107 = Super_L" "$HOME/.Xmodmap" || echo "keycode 107 = Super_L" >> "$HOME/.Xmodmap"
command xmodmap "$HOME/.Xmodmap"

# Optional directories
mkdir -p "$HOME/Projects" "$HOME/Study"

# Disable the beep
rmmod pcspkr
sudo echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
