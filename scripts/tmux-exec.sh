#!/bin/sh

SESSION_NAME="$1"
case "$#" in
	3)
		WINDOW_NAME="$2"
		CMD="$3"
		;;
	2)
		CMD="$2"
		;;
	*)
		echo "Usage: $(basename $0) <SESSION_NAME> [<WINDOW_NAME>] <CMD>"
		exit 1
		;;
esac

CUR_SESSION=$(tmux display-message -p '#{session_name}')
if tmux has-session -t "$SESSION_NAME" 2> /dev/null; then
	if [ -z "$WINDOW_NAME" ]; then
		tmux new-window -d -t "$SESSION_NAME:" "$CMD"
	else
		tmux new-window -d -t "$SESSION_NAME:" -n "$WINDOW_NAME" "$CMD"
	fi
else
	if [ -z "$WINDOW_NAME" ]; then
		tmux new-session -d -s "$SESSION_NAME" "$CMD"
	else
		tmux new-session -d -s "$SESSION_NAME" -n "$WINDOW_NAME" "$CMD"
	fi
fi
tmux switch-client -t "$CUR_SESSION"
