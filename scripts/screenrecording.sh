#!/bin/sh

# Capture a screen recording of part of the screen

SCREENRECORDINGS_DIR=~/Downloads/screenrecordings

case "$1" in
	"toggle")
		# If there is an ongoing screenrecording, end it, otherwise start a new one
		if pgrep wf-recorder > /dev/null; then
			$0 end
		else
			$0 start
		fi
		;;
	"start")
		echo "Starting screenrecording"

		mkdir -p $SCREENRECORDINGS_DIR

		# Format: YYYYMMDD_HHhMMmSSs
		timestamp=$(date +"%Y%m%d_%Hh%Mm%Ss")
		# TODO: change to .mkv (only .mp4 because github does not support .mkv)
		file_name="screenrecording_${timestamp}.mp4"
		file="$SCREENRECORDINGS_DIR/$file_name"

		# TODO: maybe copy path of recording to clipboard for quick retrieval

		# If a specific region is selected with `slurp`, record only that region
		if captured_region="$(slurp)"; then
			wf-recorder --file "$file" --geometry "$captured_region" &
		else
			wf-recorder --file "$file" &
		fi

		if [ "$?" -ne 0 ]; then
			notify-send "Failed to start screenrecording" -t 1000 -u critical
		fi

		# Notify waybar
		pkill -RTMIN+5 waybar
		;;
	"end")
		echo "Ending screenrecording"

		# Kill the `wf-recorder` process, which ends the screenrecording
		pkill -SIGINT wf-recorder

		if [ "$?" -eq 0 ]; then
			notify-send "Screenrecording completed" -t 1000

			# Notify waybar
			pkill -RTMIN+5 waybar
		else
			notify-send "Failed to end screenrecording" -t 1000 -u critical
		fi
		;;
	*)
		echo "$(basename $0) [start|end|toggle]" 1>&2
		exit 1
		;;
esac
