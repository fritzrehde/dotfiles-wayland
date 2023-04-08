#!/bin/sh

# notify once command is executed

eval "$1"
notify-send "Done" "$1"
