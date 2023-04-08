#!/bin/sh

tmux-exec.sh update "notify.sh \"notify-send sudo; sudo pacman -Syu --noconfirm\""
