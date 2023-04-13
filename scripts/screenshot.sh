#!/bin/sh

export GRIM_DEFAULT_DIR=$HOME/Downloads/screenshots
# CMD='echo -n $f | xclip -selection clipboard -i'

case "$1" in
	"select")
		grim -g "$(slurp)"
		;;
	*)
		grim
		;;
esac

if [ "$?" -eq 0 ]; then
	notify-send "Screenshot taken" -t 1000
fi
