#!/bin/sh

cmd="$(rofi.sh top -p "shell")" || exit 1
eval "$cmd"
