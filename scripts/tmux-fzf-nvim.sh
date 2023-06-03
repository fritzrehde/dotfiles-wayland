#!/bin/sh

if [ "$#" -eq 1 ]; then
	# TODO: migrate to official tmux config
	tmux display-popup -w 50% -h 60% -E "fzf-nvim.sh $1"
else
	echo "Usage: $(basename $0) [fzf-nvim.sh option]" 1>&2
	exit 1
fi
