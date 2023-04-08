#!/bin/sh

MAN="$(rofi.sh bottom -p man)" || exit 1
tmux new-window -a "man $MAN"

# tmux command-prompt -p "man" "new-window -a \"man %1\""
