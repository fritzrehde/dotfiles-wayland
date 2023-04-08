#!/bin/sh

# TODO: add global colors
BBlue='\033[1;34m'
SEARCH="$(rofi.sh bottom -p find)" || exit 0
CUR_PATH="$(tmux display-message -p '#{pane_current_path}')"

CMD="rg --ignore-case --files-with-matches --no-messages '$SEARCH' ${CUR_PATH} \
	| fzf.sh --exit-0 --preview-window 'nohidden' \
		--preview \"printf '${BBlue}{}\n'; rg --ignore-case --pretty --colors 'match:fg:black' --colors 'match:bg:yellow' --context 10 '$SEARCH' {}\" \
	| tac | xargs -I {} tmux new-window -ad \"nvim {}\""

BEFORE=$(tmux display-message -p '#{session_windows}')
tmux display-popup -w 90% -h 60% -E "$CMD"
AFTER=$(tmux display-message -p '#{session_windows}')
[ "$BEFORE" -ne "$AFTER" ] && tmux next-window
