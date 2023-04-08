#!/bin/sh

killall -q dunst
while pgrep -x dunst > /dev/null; do sleep 0.01; done
dunst
