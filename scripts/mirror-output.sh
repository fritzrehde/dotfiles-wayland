#!/bin/sh

output="$(swaymsg -t get_outputs | jq -r '.[] | .name' | rofi.sh -p "mirror")" || exit 0

wl-mirror "$output"
