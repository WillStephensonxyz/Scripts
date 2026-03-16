#!/bin/bash

# to do
# configure terminal settings for urxvt
# disable terminal bell
# configure i3-status
# configure gaps 
# configure transparent terminal
# configure custom keybind
# fix setting background

PACKAGES=("i3" "i3status" "dmenu" "urxvt" "feh" "xmodmap")

CONFIG_FILE="https://raw.githubusercontent.com/WillStephensonxyz/dotfiles/refs/heads/main/i3-kde/config"
XRESOURCES="https://raw.githubusercontent.com/WillStephensonxyz/dotfiles/refs/heads/main/i3-Xresources/.Xresources"

CONFIG_DIR="$HOME/.config/i3"
CONFIG_PATH="$CONFIG_DIR/config"
XRESOURCES_PATH="$HOME/.Xresources"
KACCESSRC="$HOME/.config/kaccessrc"

echo "Checking packages" 
for PACKAGE in ${PACKAGES[@]}; 
do
	if rpm -q "${PACKAGE}" > /dev/null  2>&1; then
		echo "$PACKAGE" already installed
	else
		sudo dnf install -y "$PACKAGE"
		continue
	fi
done

echo "Configuring i3"
if [[ -f "$CONFIG_PATH" ]]; then
	echo "i3 config already exists"
else
	echo "creating i3 config file"
	mkdir -p "$CONFIG_DIR"
	curl -o "$CONFIG_PATH" "$CONFIG_FILE"
fi

echo "Disable KDE bell" 
if [[ -f "$KACCESSRC" ]] && grep -q "Systembell=true" "$KACCESSRC"; then 
	sed -i "s/true/false/g" ~/.config/kaccessrc
fi

echo "Configuring urxvt"
if [[ -f "$XRESOURCES_PATH" ]]; then 
	echo ".Xresoures already exists"
else
	echo "creating .Xresources"
	curl -o "$XRESOURCES_PATH" "$XRESOURCES"
fi

echo "Configuring Xmodmap"
if grep -q "keycode 107 = Super_L" "$XRESOURCES"; then 
	echo "keycode 107 = Super_L" >> "$XRESOURCES"
	xrdb merge "$XRESOURCES"
fi
