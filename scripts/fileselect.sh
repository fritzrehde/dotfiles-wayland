#!/bin/sh

# select files in new terminal and return results

EXTENSIONS="$1"
TMP="$(mktemp --dry-run "/tmp/XXXXXX")"
kitty --class floating_wide sh -c \
	"fd --no-ignore --type file --type directory --absolute-path $EXTENSIONS | fzf.sh -d "/" --with-nth 4.. > $TMP"
STDOUT="$(cat "$TMP")"
rm -f "$TMP"
[ -n "$STDOUT" ] && echo "$STDOUT"
