#!/bin/sh

# get and set current color theme

# TODO: don't hardcode
THEME_FILE=~/git/dotfiles-wayland/theme

if [ -n "$1" ]; then
	# set
	echo "$1" > "$THEME_FILE"
else
	# get
	cat "$THEME_FILE"
fi
