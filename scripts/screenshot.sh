#!/bin/sh

OUTPUT=/home/fritz/Downloads/screenshots/%Y-%m-%d-%T.png
CMD='echo -n $f | xclip -selection clipboard -i'

case "$1" in
	"select")
		scrot "$OUTPUT" --select --line mode=edge --silent -e "$CMD"
		;;
	*)
		scrot "$OUTPUT" --silent -e "$CMD"
		;;
esac

notify-send "Screenshot taken" -t 1000
