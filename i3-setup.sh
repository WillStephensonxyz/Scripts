#!/bin/bash

# to do
# disable terminal bell
# configure i3-status
# configure gaps (add to master config)
# configure transparent terminal
# import programs from kde (kdewallet) or replace

packages=("i3" "i3status" "dmenu" "picom" "rxvt-unicode" "feh" "xmodmap")

i3_config_file="https://raw.githubusercontent.com/WillStephensonxyz/dotfiles/refs/heads/main/i3-kde/config"
xresources_config="https://raw.githubusercontent.com/WillStephensonxyz/dotfiles/refs/heads/main/i3-Xresources/.Xresources"
# picom_config=""

config_dir="$HOME/.config/i3"
config_path="$config_dir/config"
xresources_path="$HOME/.Xresources"
picom_dir="$HOME/.config/picom"
picom_path="$HOME/.config/picom/picom.conf"
kaccessrc="$HOME/.config/kaccessrc"
xmodmap="$HOME/.Xmodmap"

package_list() {  

	echo "[*] Checking packages" 

	for package in ${packages[@]}; 
	do
		if rpm -q "${package}" > /dev/null  2>&1; then
			echo "$package" already installed
		else
			sudo dnf install -y "$package"
			continue
		fi
	done
} 

configure_i3() {

	echo "[*] Configuring i3"
	if [[ -f "$config_path" ]]; then
		echo "i3 config already exists"
	else
		echo "creating i3 config file"
		mkdir -p "$config_dir"
		curl -o "$config_path" "$i3_config_file"
	fi
}

configure_urxvt() {

	echo "[*] Configuring urxvt"
	if [[ -f "$xresources_path" ]]; then 
		echo ".Xresoures already exists"
	else
		echo "creating .Xresources"
		curl -o "$xresources_config" "$xresources_path"
	fi
}

echo 

configure_picom() {

	echo "[*] Configuring picom"
	if [[ ! -f "$picom_path" ]]; then
		mkdir -p "$picom_dir" 
		# curl -o "
}

configure_xmodmap() {

	echo "[*] Configuring Xmodmap"	
	if [[ ! -f "$xmodmap" ]]; then 
		touch "$xmodmap"
		echo "keycode 107 = Super_L" > "$xmodmap"
		xmodmap "$xmodmap"
	elif [[ -f "$xmodmap" ]] && ! grep -q "keycode 107 = Super_L" "$xmodmap"; then
		echo "keycode 107 = Super_L" >> "$xmodmap"
		xmodmap "$xmodmap"
	fi 
}

kde_bell() {

	echo "[*] Disabling KDE bell" 
	if [[ -f "$kaccessrc" ]] && grep -q "SystemBell=true" "$kaccessrc"; then 
		sed -i "s/true/false/g" ~/.config/kaccessrc
	fi
}

main() {
	package_list
	configure_i3
	configure_urxvt
	configure_xmodmap
	kde_bell
}

main
