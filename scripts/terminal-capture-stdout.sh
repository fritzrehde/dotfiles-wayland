#!/bin/sh

CMD="$@"
TMP="$(mktemp "/tmp/XXXXXX")"

alacritty -e sh -c "$CMD > $TMP" 2>/dev/null

STDOUT="$(cat "$TMP")"
rm -f "$TMP"
[ -n "$STDOUT" ] && echo "$STDOUT"
