#!/bin/sh

case "$1" in
	list)
		# TODO: show all labels, not just first
		JSON=$(gh issue list --json number,author,title,labels)
		echo "$JSON" | jq -r '.[] | "\(.number),\(.author.login),\(.title),\(.labels[].name)"' \
			| column -ts ','
		;;
	create)
		;;
	close)
		;;
	*)
		# TODO: exec
		watchbind -c ~/dotfiles/config/watchbind/gh-issues.toml
esac
