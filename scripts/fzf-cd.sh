#!/bin/sh

current_window=$(tmux display-message -p '#{window_index}')
search_path=$(tmux display-message -p '#{pane_current_path}')
base_path=.
# if [ "$search_path" = "$HOME" ]; then
	# search_path=~/code
	# base_path=$search_path
# fi
new_path=$(fd --type d --base-directory $search_path | fzf.sh +m -0)

[ -n "$new_path" ] \
	&& tmux send-keys -t "$current_window" "cd $base_path/$new_path; clear" ENTER
