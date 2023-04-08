#!/bin/sh

case $# in
	0)
		exit 1
		;;
	1)
		tmux new-window -a "nvim $1" 
		;;
	*)
		for a in $(printf "%s " "$@" | tac -s " ")
		do
			tmux new-window -ad "nvim $a" 
		done
		tmux next-window
		;;
esac
