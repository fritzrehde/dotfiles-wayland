#!/bin/sh

CUR_SESSION=$(tmux display-message -p '#S')

# create "misc" session in case non-existent
tmux new-session -s "misc" -d

if [ "$CUR_SESSION" = "misc" ] ; then
	# restart misc instead of killing
	tmux new-session -ds temp 2> /dev/null
	tmux switch-client -t temp
	tmux kill-session -t misc
	tmux new-session -ds misc 2> /dev/null
	tmux switch-client -t misc
	tmux kill-session -t temp
else
	tmux switch-client -t misc
	tmux kill-session -t "$CUR_SESSION"
fi
