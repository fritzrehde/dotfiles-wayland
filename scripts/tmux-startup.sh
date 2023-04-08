#!/bin/sh

if [ $# -eq 1 ]; then
	tmux new-session -As "$1"
else
	tmux new-session -As "misc"
fi
