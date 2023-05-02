#!/bin/bash

# TODO: rewrite in python

case "$1" in
	add)
		# add multiple todos (!-suffix means priority A) to todo.sh

		raw=$(rofi.sh top -p "todo") || exit 1

		single_seperator=${raw//; /;}

		IFS=';' read -ra todos <<< "$single_seperator"
		for i in "${todos[@]}"
		do
			# convert "!" suffix to importance
			if [ "$(echo "$i" | awk '{ print $NF }')" = "!" ]; then
				MOD=${i::-2}
				i="(A) $MOD"
			fi
			todo.sh add "$i"
		done
		;;
	toggle-prio)
		# TODO: toggle through all priorities
		shift
		for line in "$@"; do
			HAS_PRIO=$(todo.sh pri "$line" A)
			[ -n "$HAS_PRIO" ] \
				&& todo.sh depri "$line"
		done
		exit 0
		;;
	list)
		FZF_OPTS=$(
			tr -d '\n' <<-END
			--bind=
			alt-j:down,
			alt-k:up,
			alt-l:execute-silent(todo.sh -fnA do {+1})+reload(todo.sh -P ls),
			alt-i:execute-silent(todo-txt.sh toggle-prio {+1})+reload(todo.sh -P ls)
			END
		)

		terminal-capture-stdout.sh "todo.sh -P ls | fzf.sh \"$FZF_OPTS\" -e --ansi --with-nth=2.." \
			| awk '{print $1}' | tr '\n' ' ' | xargs -I % todo.sh -fnA do %
		;;
	*)
		echo "Usage: $(basename $0) [add|list]" 1>&2
		exit 1
		;;
esac

(
	TODO_DIR="${HOME}/git/todo.txt"

	git_() {
		git -C "$TODO_DIR" "$@"
	}

	if ! git_ diff --quiet todo.txt; then
		COMMIT_MSG="Automatically updated with script"

		git_ add todo.txt \
			&& git_ commit -m "$COMMIT_MSG" \
			&& git_ push \
			|| notify-send -u critical "Pushing todos failed"
	fi
) > /dev/null 2>&1 &
