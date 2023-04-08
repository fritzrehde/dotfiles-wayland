#!/bin/sh

# download lecturio videos from selected courses

COURSES=$(
	cat <<-END
	economics-ii-wi000023_e-macroeconomics-ss-2022.kurs
	END
)

download() {
	URL="$1"
	USERNAME="$2"
	PASSWORD="$3"
	SUBJECT="$(echo "$URL" | tr "/" "\n" | grep ".kurs" | sed 's/\.kurs//')"
	DIR=~/Downloads/videos/$SUBJECT
	mkdir -p $DIR

	# assumption: filename and url don't contain spaces
	LECTURES=$(
		yt-dlp \
			-u "$USERNAME" -p "$PASSWORD" \
			-o "$DIR/%(title)s.%(ext)s" \
			--print "%(filename)s %(webpage_url)s" \
			"$URL"
	)
	LECTURE_NAMES="$(echo "$LECTURES" | cut -d " " -f 1)"

	# check if files (from stdin) have already been downloaded
	if echo "$LECTURE_NAMES" | xargs -I {} ls "{}" > /dev/null 2>&1; then
		notify-send "Up to date" "$SUBJECT" -t 0
	else
		echo "$LECTURE_NAMES" | while read LECTURE_NAME; do
			if [ ! -f "$LECTURE_NAME" ]; then
				LECTURE_URL="$(echo "$LECTURES" | grep "$LECTURE_NAME" | cut -d " " -f 2)"
				yt-dlp.sh \
					--notify-title "$SUBJECT" \
					-u "$USERNAME" -p "$PASSWORD" \
					-o "$LECTURE_NAME" \
					--embed-metadata \
					"$LECTURE_URL" &
			fi
		done
	fi
}

# lecturio login credentials
USERNAME="$(ls ~/.password-store/uni/lecturio.de | sed 's/\.gpg//')"
PASSWORD="$(pass uni/lecturio.de/$USERNAME)"

for COURSE in $(echo "$COURSES"); do
	download "https://www.lecturio.de/elearning/$COURSE" "$USERNAME" "$PASSWORD" &
done
