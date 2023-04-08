#!/bin/sh

case "$1" in
	list)
		pacman -Qi | grep -E '^(Name|Installed)' \
			| awk '{ print $2 }' FS=" : " OFS="," \
			| paste -d "," - - | grep "MiB" | sort -nrk 2 -t "," \
			| column -s "," -t
		;;
	delete-cache)
		sudo pacman -Sc
		;;
	*)
		echo "Usage: $(basename $0) [list|delete-cache]" 1>&2
		exit 1
		;;
esac
