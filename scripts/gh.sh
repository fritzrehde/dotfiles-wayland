#!/bin/sh

error() {
	echo "Usage: $(basename $0) new <NEW-REPO-NAME>"
}

case $1 in
	new)
		if [ -n "$2" ]; then
			gh repo create "$2" --clone --private
		else
			error
		fi
		# cd ./$2
		;;
	*)
		error
		;;
esac
