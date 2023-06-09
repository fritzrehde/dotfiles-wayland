#!/bin/sh

# FILENAME=$(rofi.sh top) || exit 1

SESSION_NAME="download"
CMD="download.sh \"$(clipboard.sh paste)\""
[ -n "$FILENAME" ] \
	&& CMD="$CMD \"$FILENAME\""

tmux-exec.sh "$SESSION_NAME" "$FILENAME" "$CMD"
