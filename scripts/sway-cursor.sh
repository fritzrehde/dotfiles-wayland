#!/bin/sh

# Toggle between hiding after timeout and showing cursor in sway

case "$1" in
	hide) TIMEOUT=1500 ;;
	show) TIMEOUT=0 ;;
	*)
		echo "Usage: $(basename $0) [hide|show]" 1>&2
		exit 1
		;;
esac

swaymsg "seat * hide_cursor $TIMEOUT"
