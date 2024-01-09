#!/bin/sh

case "$1" in
	list)
		nmcli --fields "SSID,IN-USE,BARS,SIGNAL,RATE,SECURITY" --terse --colors "no" device wifi list
		;;
	connect)
		SSID="$(echo "$lines" | cut -d ":" -f 1)"
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
		SSID="$(echo "$lines" | cut -d ":" -f 1)"
		nmcli connection down "$SSID" \
			&& notify-send "Disconnected \"$SSID\""
		;;
	*)
		watchbind -c $XDG_CONFIG_HOME/watchbind/wifi.toml
		;;
esac
