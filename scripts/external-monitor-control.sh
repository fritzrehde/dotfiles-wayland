#!/bin/sh

# Change the display settings on external monitors

# feature codes
brightness="0x10"

send_notification() {
	bright="$(ddcutil getvcp --terse "$brightness" | cut -d " " -f 4)"
	notify-send "Brightness (external): ${bright}" -a "ignorehistory" -u low -t 2000 -r 9984 -h int:value:"${bright}"
}

case "$1" in
	brightness-up)
		ddcutil setvcp "$brightness" + 5
		;;
	brightness-down)
		ddcutil setvcp "$brightness" - 5
		;;
	brightness-set)
		value="$2"
		if [ -z "$value" ]; then
			echo "Usage: $(basename $0) brightness-set <VALUE>" 1>&2
			exit 1
		fi
		ddcutil setvcp "$brightness" "$value"
		;;
	*)
		echo "Usage: $(basename $0) [brightness-up|brightness-down|brightness-set <val>]" 1>&2
		exit 1
		;;
esac

send_notification
