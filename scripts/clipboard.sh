#!/bin/sh

case "$1" in
	copy)
		wl-copy
		;;
	paste)
		# xclip -selection clipboard -o
		wl-paste
		;;
	rofi-copy)
		rofi.sh top -p "copy" | clipboard.sh copy
		;;
	rofi-paste)
		cliphist list | rofi.sh top -p "copy" -display-columns 2 | cliphist decode | wl-copy
		;;
esac
