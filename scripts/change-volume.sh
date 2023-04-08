#!/bin/sh

send_notification() {
	notify-send "Volume: ${vol}%" -a "ignorehistory" -u low -t 1000 -r 9999 -h int:value:"${vol}"
}

set_volume() {
	pamixer --unmute --set-volume "$vol" --allow-boost
	send_notification
}

vol=$(pamixer --get-volume)

case "$1" in
	up)
		if [ $(( $vol % 5 )) -eq 0 ]; then
			vol=$(( $vol + 5 ))
		else
			vol=$(( ($vol + 4) / 5 * 5 ))
		fi
		set_volume
		;;
	down)
		if [ $(( $vol % 5 )) -eq 0 ]; then
			vol=$(( $vol - 5 ))
		else
			vol=$(( $vol / 5 * 5 ))
		fi
		set_volume
		;;
	mute)
		pamixer --toggle-mute
		if [ "$(pamixer --get-mute)" = "true" ]; then
			notify-send "Muted" -a "ignorehistory" -u low -t 1000 -r 9999
		else
			send_notification
		fi
		;;
esac
# polybar-reload.sh mute
