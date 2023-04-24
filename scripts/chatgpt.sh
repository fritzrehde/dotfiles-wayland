#!/bin/sh

# define ANSI escape codes for colors
BLUE="\033[0;34m"
GREEN="\033[0;32m"
NC="\033[0m" # no nolor

fail() {
	echo "Error: $1" 1>&2
	exit 1
}

# get openai api key
export OPENAI_API_KEY="$(pass apikeys/openai)" || fail "failed to access openai api key"

# get session name from arguments
SESSION_NAME="$1"
[ -n "$SESSION_NAME" ] || fail "Usage: $(basename $0) <session-name>"

# get query from $EDITOR
if [ -z "$query" ]; then
	tmp_file="$(mktemp)" || fail "failed to create temporary file for editor"
	$EDITOR "$tmp_file"
	query="$(cat "$tmp_file")"
	rm "$tmp_file"
fi

# print query
printf "${BLUE}query:${NC}\n${query}\n\n"

# print chatgpt response
printf "${GREEN}response:${NC}\n"
chatblade \
	--session "$SESSION_NAME" \
	--stream \
	--raw \
	--no-format \
	--only \
	"$query"

# notify on completion
notify-send "Chatgpt response" "$(printf "$query" | head -n 1)"
