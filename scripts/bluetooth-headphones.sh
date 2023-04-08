#!/bin/sh

# statusbar script for bluetooth headphone connection

btctl() {
	# use usb bluetooth controller instead of default
	ARGS="$*"
	printf "select ${BT_USB_CONTROLLER}\n${ARGS}\n" | bluetoothctl
	# bluetoothctl -- "select ${BT_USB_CONTROLLER}\n${ARGS}\n"
}
connected() {
	btctl info "$BT_HEADPHONES" | grep -q "Connected: yes"
}
battery() {
	based-connect --battery-level "$BT_HEADPHONES"
	 true
}

BT_USB_CONTROLLER="$(btctl list | grep -G "Controller .* thickpad-usb" | cut -d " " -f 2)"
BT_HEADPHONES="$(btctl devices | grep -G "Device .* Fritz's Bose QC35" | cut -d " " -f 2)"

case "$1" in
	connect)
		notify-send "Attempting connection"
		btctl connect "$BT_HEADPHONES" && dunstctl close
		;;
	*)
		if connected; then
			if BAT="$(battery)"; then
				printf "%s" " $BAT%"
			else
				printf "%s" ""
			fi
		else
			printf "%s" "ﳌ"
		fi
		;;
esac
