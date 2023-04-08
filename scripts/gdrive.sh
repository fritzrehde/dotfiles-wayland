#!/bin/sh

file_ids() {
	echo "$LINES" | awk '{ print $1 }' FS="   "
}

upload() {
	FILE="$1"
	ID="$(notify-id.sh lock)"
	TITLE="$(basename "$FILE")"
	IFS=',' # for read while loop
	stdbuf -oL gdrive upload -r "$FILE" 2>&1 \
		| stdbuf -i0 -oL tr '\r' '\n' \
		| grep --line-buffered -e "[^[:blank:]].*Rate:" \
		| stdbuf -i0 -oL sed -e 's/ //g' -e 's/\//,/' -e 's/,Rate:/,/' -e 's/B//g' -e 's/\/s//' \
		| stdbuf -i0 -oL numfmt -d "," --field=- --from=auto \
		| stdbuf -i0 -oL awk '{ printf "%02d,%.1f MB/s,%d MB\n", $1*100/$2, $3/1000000, $2/1000000 }' FS="," \
		| while read PERC SPEED SIZE; do 
		notify-send "Upload ${PERC}% at ${SPEED} of ${SIZE}" "$TITLE" -r "$ID" -h "int:value:${PERC}" -t 0
	done
	notify-id.sh unlock "$ID"
}

case "$1" in
	list)
		gdrive list --no-header --name-width 0 --order name --max 500 \
			| grep bin \
			| sed 's/   */,/g' \
			| cut -f 1,2,4 -d "," --output-delimiter "," \
			| column -t -s "," -o "   "
		;;
	delete)
		# file_ids | parallel 'gdrive3 files delete "{}"'
		file_ids | parallel 'gdrive delete "{}"'
		;;
	download)
		# TODO: do in parallel or all at once!
		file_ids | xargs -I {} gdrive download "{}"
		;;
	upload)
		fileselect.sh "-e mp4 -e mkv -e webm" | while read FILE; do
			upload "$FILE" &
		done
		;;
	space-used)
		BYTES_SUM=$(
			gdrive list --no-header --name-width 0 --order name --max 500 --bytes \
				| grep bin \
				| sed 's/   */,/g' \
				| cut -d "," -f 4 --output-delimiter "," \
				| tr -dc '0-9,\n' \
				| tr '\n' '+'
		)
		# "...+0"
		SPACE_USED="$(echo "${BYTES_SUM}0" | bc | numfmt --to=si --format="%.2f")"
		notify-send "gdrive: space used" "$SPACE_USED"
		;;
	*)
		watchbind --config-file ~/dotfiles/config/watchbind/gdrive.toml
		;;
esac
