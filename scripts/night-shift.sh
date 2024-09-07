#!/bin/sh

night_shift_program="gammastep"

get_state() {
	if pgrep "$night_shift_program" >/dev/null; then
		echo "on"
	else
		echo "off"
	fi
}

case "$1" in
	state)
		get_state
		;;
	toggle)
		case "$(get_state)" in
			on)
				"$0" off
				;;
			off)
				"$0" on
				;;
			*)
				echo "got other state: $(get_state)"
				;;
		esac
		;;
	on)
		echo "Turning night shift on"
		# Restart program (in case it's already running).
		pkill "$night_shift_program"
		"$night_shift_program" &
		;;
	off)
		echo "Turning night shift off"
		pkill "$night_shift_program"
		;;
esac
