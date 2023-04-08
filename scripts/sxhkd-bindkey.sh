#!/bin/bash

if [ "$(xdotool getactivewindow getwindowname)" = "st" ]; then
	bash -c "$2"
else
	# xdotool key "$1"
	xdotool key --window getwindowfocus $1
fi
