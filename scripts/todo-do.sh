#!/bin/sh

case "$1" in
	toggle-prio)
		shift
		for i in "$@"; do
			HAS_PRIO=$(todo.sh pri "$i" A)
			[ -n "$HAS_PRIO" ] \
				&& todo.sh depri "$i"
		done
		;;
	*)
		FZF_OPTS=$(
			tr -d '\n' <<-END
			--bind=
			L:execute-silent(todo.sh -fnA do {+1})+reload(todo.sh -P ls),
			I:execute-silent(todo-do.sh toggle-prio {+1})+reload(todo.sh -P ls)
			END
		)

		todo.sh -P ls \
			| fzf.sh "$FZF_OPTS" -e --ansi --with-nth=2.. \
			| awk '{print $1}' | tr '\n' ' ' | xargs -I % todo.sh -fnA do %
		;;
esac
