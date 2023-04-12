#!/bin/sh

GRIM_DEFAULT_DIR=$HOME/Downloads/screenshots
# OUTPUT=/home/fritz/Downloads/screenshots/%Y-%m-%d-%T.png
# CMD='echo -n $f | xclip -selection clipboard -i'

case "$1" in
	"select")
		# scrot "$OUTPUT" --select --line mode=edge --silent -e "$CMD"
		grim -g "$(slurp)"
		;;
	*)
		# scrot "$OUTPUT" --silent -e "$CMD"
		grim
		;;
esac

notify-send "Screenshot taken" -t 1000
