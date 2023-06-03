#!/bin/sh

rofi \
	-show calc -mode calc \
	-no-show-match -no-sort \
	-calc-command "printf '{result}' | wl-copy" \
	-theme ~/.config/rofi/themes/default-$(theme.sh).rasi

