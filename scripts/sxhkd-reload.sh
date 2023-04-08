#!/bin/sh

pkill -USR1 -x sxhkd; notify-send "sxhkd reloaded" -a "ignorehistory" -t 500 -r 9997
