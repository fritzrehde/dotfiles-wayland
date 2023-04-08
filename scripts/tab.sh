#!/bin/sh

# convert spaces to tabs in provided files

TAB_SIZE=$1
shift

for a in "$@"
do
	unexpand -t "$TAB_SIZE" "$a" > "$a-notab"
	mv "$a-notab" "$a"
done
