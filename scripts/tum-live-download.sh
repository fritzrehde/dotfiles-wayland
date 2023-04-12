#!/bin/sh

URL="$(clipboard.sh paste)"
LECTURE="$(echo "$URL" | tr "/" "\n" | grep ".mp4" | sed 's/\.mp4//')"
SUBJECT="$(echo "$LECTURE" | cut -d '_' -f 1 | tr '[A-Z]' '[a-z]')"
DIR=~/Downloads/videos/$SUBJECT
mkdir -p "$DIR"

yt-dlp.sh \
	--parse-metadata "$LECTURE:%(title)s" \
	-o "$DIR/$LECTURE.%(ext)s" \
	--embed-metadata \
	"$URL"
