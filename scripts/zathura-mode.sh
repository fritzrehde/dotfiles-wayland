#!/bin/sh

PDF="$1"
CONFIG="$2"
START_DESKTOP=$(bspc query --desktops --desktop focused --names)

xdo close "$(xdo id)"

bspc rule -a Zathura --one-shot desktop="$START_DESKTOP"
case "$3" in
	normal)
		zathura -c ~/.config/$CONFIG "$PDF" &
		;;
	fullscreen)
		zathura -c ~/.config/$CONFIG "$PDF" --mode fullscreen &
		;;
esac
