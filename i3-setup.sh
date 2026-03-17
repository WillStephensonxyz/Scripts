#!/bin/bash

# to do
# disable terminal bell
# configure i3-status
# import programs from kde (kdewallet) or replace
# test

packages=("i3" "i3status" "dmenu" "picom" "rxvt-unicode" "feh" "xmodmap")

i3_config="https://raw.githubusercontent.com/WillStephensonxyz/dotfiles/refs/heads/main/i3-laptop-rice/i3-kde/config"
xresources_config="https://raw.githubusercontent.com/WillStephensonxyz/dotfiles/refs/heads/main/i3-laptop-rice/i3-Xresources/.Xresources"
picom_config="https://raw.githubusercontent.com/WillStephensonxyz/dotfiles/refs/heads/main/i3-laptop-rice/i3-picom/picom.conf"

i3_dir="$HOME/.config/i3"
i3_path="$HOME/.config/i3/config"
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
	if [[ ! -f "$i3_path" ]]; then
		echo "creating i3 config file"
		mkdir -p "$i3_dir"
		curl -o "$i3_path" "$i3_config"
	fi
}

configure_urxvt() {

	echo "[*] Configuring urxvt"
	if [[ ! -f "$xresources_path" ]]; then
		echo "creating .Xresources"
		curl -o "$xresources_config" "$xresources_path" 
	fi
}

configure_picom() {

	echo "[*] Configuring picom"
	if [[ ! -f "$picom_path" ]]; then
		mkdir -p "$picom_dir" 
		curl -o "$picom_path" "$picom_config"
	fi
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
	configure_picom
	configure_xmodmap
	kde_bell
	
}

main
