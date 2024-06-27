#!/bin/sh

# A wrapper around `pdftk` for editing PDFs.

case "$1" in
	merge)
		shift
		pdftk "$@" cat output merged.pdf
		;;
	pages)
		range="$2"
		file="$3"
		pdftk "$file" cat $range output new.pdf
		;;
	*)
		echo "Usage: $(basename $0) [merge|pages <range>] <input.pdf>"
		exit 1
		;;
esac
