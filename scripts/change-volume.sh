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
		# set volume to nearest multiple of 5 larger than original volume
		if [ $(( $vol % 5 )) -eq 0 ]; then
			vol=$(( $vol + 5 ))
		else
			vol=$(( ($vol + 4) / 5 * 5 ))
		fi
		set_volume
		;;
	down)
		# set volume to nearest multiple of 5 smaller than original volume
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
	mic-mute)
			notify-send "Mic Muted" -a "ignorehistory" -u low -t 1000 -r 9999
		;;
	*)
		echo "Usage: $(basename $0) [up|down|mute|mic-mute]"
		exit 1;
		;;
esac
# polybar-reload.sh mute
