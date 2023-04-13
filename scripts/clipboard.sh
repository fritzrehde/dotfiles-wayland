#!/bin/sh

case "$1" in
	copy)
		wl-copy
		;;
	paste)
		# xclip -selection clipboard -o
		wl-paste
		;;
	rofi)
		# cliphist list | cut -f 2- | rofi.sh | wl-copy
		cliphist list | rofi.sh top -display-columns 2 | cliphist decode | wl-copy
		;;
esac
