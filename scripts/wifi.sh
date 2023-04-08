#!/bin/sh

case "$1" in
	list)
		nmcli --fields "SSID,IN-USE,BARS,SIGNAL,RATE,SECURITY" --terse --colors "no" device wifi list \
			| column -t -s ":" -o "  "
		;;
	connect)
		SSID="$(echo "$LINES" | awk '{ print $1 }' FS="  ")"
		if nmcli connection up "$SSID"; then
			notify-send "Connected \"$SSID\""
		else
			if nmcli device wifi connect "$SSID" password "$(rofi.sh top -p password)"; then
				notify-send "Connected \"$SSID\""
			else
				notify-send "Failed \"$SSID\""
			fi
		fi
		;;
	disconnect)
		SSID="$(echo "$LINES" | awk '{ print $1 }' FS="  ")"
		nmcli connection down "$SSID" \
			&& notify-send "Disconnected \"$SSID\""
		;;
	*)
		watchbind -c ~/dotfiles/config/watchbind/wifi.toml
		;;
esac
