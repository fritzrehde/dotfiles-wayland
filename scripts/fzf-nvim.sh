#!/bin/bash

FZF_OPTS=(--preview="cat {}")
case "$1" in
	config)
		SEARCH_PATH=~/git/dotfiles-wayland/config
		FILES=$(fd --hidden -t f . $SEARCH_PATH | sed 's/\/home\/fritz\/git\/dotfiles\/config\///')
		;;
	scripts)
		SEARCH_PATH=~/git/dotfiles-wayland/scripts
		FILES=$(fd -t f . $SEARCH_PATH | sed 's/\/home\/fritz\/git\/dotfiles\/scripts\///')
		;;
	*)
		CURRENT_PATH=$(tmux display-message -p '#{pane_current_path}')
		if SEARCH_PATH=$(git -C "$CURRENT_PATH" rev-parse --show-toplevel 2> /dev/null); then
			FZF_OPTS+=("--header=$(basename "$SEARCH_PATH")")
		else
			SEARCH_PATH=$CURRENT_PATH
		fi
		FILES=$(cd "$SEARCH_PATH" || exit; fd -t f --base-directory "$SEARCH_PATH")
		;;
esac

count=$(tmux display-message -p '#{session_windows}')
(cd "$SEARCH_PATH" || exit; echo "$FILES" | fzf.sh "${FZF_OPTS[@]}" | tac | xargs -I % tmux new-window -ad "nvim %")
new_count=$(tmux display-message -p '#{session_windows}')
[ "$count" -ne "$new_count" ] && tmux next-window
