#!/bin/sh

case "$1" in
	default|top|bottom|icons|power)
		MODE="$1"
		shift
		;;
	*)
		MODE="default"
		;;
esac

rofi $@ -dmenu -theme "~/.config/rofi/themes/$MODE.rasi" -i
