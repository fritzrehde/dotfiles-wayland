#!/bin/sh

# configure cursor hiding in sway

case "$1" in
	on)
		swaymsg 
		;;
	off)
		;;
	toggle)
		;;
	*)
		echo "Usage: $(basename $0) [on|off|toggle]" 1>&2
		exit 1
		;;
esac
