#!/bin/sh

OUTPUT_DIR=~/Downloads/videos
URL="$1"
OUTPUT="$2"

case $# in
	1)
		yt-dlp "$URL"
		;;
	2)
		# yt-dlp --paths "$OUTPUT_DIR" "$URL"
		yt-dlp --output "$OUTPUT_DIR"/"$OUTPUT" "$URL"
		;;
	*)
		echo "Usage: $(basename $0) <INPUT-URL> [<OUTPUT-FILENAME>]" 2>&1
		exit 1
		;;
esac
