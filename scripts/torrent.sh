#!/bin/sh

torrent_ids() {
	echo "$LINES" \
		| cut -d "," -f 1 \
		| xargs | tr ' ' ',' | tr -d '\n'
}

# match status code with status string
status_str() {
	case "$1" in
		0) printf "stopped    " ;;
		1) printf "Q verify   " ;;
		2) printf "verifying  " ;;
		3) printf "Q download " ;;
		4) printf "downloading" ;;
		5) printf "Q seed     " ;;
		6) printf "seeding    " ;;
		*)
			echo "Error: Invalid status code" 1>&2
			exit 1
			;;
	esac
}

case "$1" in
	list)
		IFS=',' # delimiter for read

		echo "ID,STATUS,BAR,PERC,DOWN,UP,NAME"
		# TODO: add ETA: support fixed specifiers, minutes, done state (displays -1)
		transmission-remote --json --list \
			| jq -r '.arguments.torrents[] | "\(.id),\(.name),\(.eta),\(.leftUntilDone),\(.sizeWhenDone),\(.rateDownload),\(.rateUpload),\(.status)"' \
			| while read id name eta size_left size_total download upload status_code; do 
					status="$(status_str "${status_code}")"

					percentage="$(echo "((${size_total} - ${size_left}) * 100) / ${size_total}" | bc 2> /dev/null)"
					[ -z "$percentage" ] && percentage=0

					progress_bar="$(asciibar --min 0 --max 100 --length=10 --border="|" ${percentage})"

					# TODO: improve fixed-float calculation (allow dynamic unit depending on speed through explizit tool)
					download="$(echo "$download" | awk '{ printf("%.1f", $1/1000000) }')"

					upload="$(echo "$upload" | awk '{ printf "%.1f", $1/1000 }')"

					printf "%d,%s,%s,%-3d%%,%s MB/s,%s KB/s,%s\n" "$id" "$status" "$progress_bar" "$percentage" "$download" "$upload" "$name"
			done
		;;
	add)
		transmission-remote --add "$(clipboard-paste.sh)"
		;;
	start)
		transmission-remote --torrent "$(torrent_ids)" --start
		;;
	stop)
		transmission-remote --torrent "$(torrent_ids)" --stop
		;;
	remove)
		transmission-remote --torrent "$(torrent_ids)" --remove
		;;
	delete)
		transmission-remote --torrent "$(torrent_ids)" --remove-and-delete
		;;
	file)
		ID=$(torrent_ids)
		# TODO: use awk to only get id
		FILE_INDEX=$(transmission-remote --torrent "$ID" --files | tail --lines="+3" | rofi.sh default -p "file") || exit 1
		transmission-remote --torrent "$ID" --get "$FILE_INDEX"
		;;
	*)
		watchbind --config-file $XDG_CONFIG_HOME/watchbind/torrent.toml
		;;
esac
