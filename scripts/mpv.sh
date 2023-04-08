#!/bin/sh

URL="$(clipboard-paste.sh)"
# START_DESKTOP=$(bspc query --desktops --desktop focused --names)

case "$1" in
	focus)
		# TODO: prints 1 even if all are occupied
		# VIDEO_DESKTOP=$(bspc query --desktops --desktop any.\!occupied --names)
		# if [ -z "$VIDEO_DESKTOP" ]; then
		# 	notify-send "No available desktops" -a "ignorehistory" -u critical -t 1000 -r 9989
		# 	exit 1
		# fi
		# bspc desktop -f "$VIDEO_DESKTOP"
		mpv --fs --profile=1080p "$URL"
		# yt-dlp --format best --output - "$URL" | mpv --fs -

		# TMP=/tmp/videos
		# mkdir "$TMP"
		# yt-dlp \
		# 	--paths "$TMP" \
		# 	--exec "mpv --fs" --exec "rm -f" \
		# 	--embed-metadata \
		# 	"$URL"
		;;
	stay)
		TMP=/tmp/videos
		mkdir -p "$TMP"
		TITLE="$(yt-dlp --print title "$URL")"
		FILE="$(mktemp --dry-run "$TMP/XXXXXX.$(yt-dlp --print ext "$URL")")"
		yt-dlp.sh \
			--output "$FILE" \
			--embed-metadata \
			"$URL"
		mpv \
			--fs --pause \
			--script-opts-append=osc-visibility=always \
			--msg-level=all=error \
			"$FILE"
		rm -f "$FILE"
		;;
esac

# bspc desktop -f "$START_DESKTOP"
