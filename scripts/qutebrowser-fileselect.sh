#!/bin/sh

[ "$#" -ne 2 ] && exit 1

case "$1" in
	directory)
		TYPE="directory"
		FZF_ARGS="+m"
		;;
	file)
		TYPE="file"
		FZF_ARGS="+m"
		;;
	files)
		TYPE="file"
		FZF_ARGS="-m"
		;;
esac

# CMD="fd --no-ignore --type $TYPE --absolute-path | fzf.sh -d "/" --with-nth 4.. $FZF_ARGS > $2"
CMD="fd --no-ignore --type $TYPE --absolute-path | fzf.sh $FZF_ARGS > $2"

# TODO: add floating back with --class floating_tall
# kitty --class floating_tall sh -c "$CMD"
alacritty --command sh -c "$CMD"
