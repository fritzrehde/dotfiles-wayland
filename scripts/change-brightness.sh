#!/bin/sh

send_notification() {
	bright="$(brightnessctl info -m | cut -d "," -f 4)"
	notify-send "Brightness: ${bright}" -a "ignorehistory" -u low -t 1000 -r 9985 -h int:value:"${bright}"
}

case "$1" in
	up)
		brightnessctl --quiet set +5%
		;;
	down)
		brightnessctl --quiet set 5%-
		;;
	*)
		echo "Usage: $(basename $0) [up|down]"
		exit 1
		;;
esac

send_notification
