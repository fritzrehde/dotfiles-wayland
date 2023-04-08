#!/bin/sh

if [ "$(theme.sh)" = "dark" ]; then
	FZF_THEME="$FZF_THEME_DARK"
else
	FZF_THEME="$FZF_THEME_LIGHT"
fi
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_THEME"

fzf "$@"
