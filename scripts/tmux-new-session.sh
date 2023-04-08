#!/bin/sh

NAME="$(rofi.sh bottom -p "tmux")" || exit 1

tmux new-session -ds "$NAME"
tmux switch-client -t "$NAME"
