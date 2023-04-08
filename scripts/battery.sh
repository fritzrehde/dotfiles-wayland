#!/bin/sh

STATUS=/sys/class/power_supply/BAT0/status
PERC=$(cat /sys/class/power_supply/BAT0/capacity)
RED="#bf616a"

if grep -q "Charging" $STATUS; then
	printf " $PERC%%"
else
	if [ "$PERC" -eq 100 ]; then
		printf " $PERC%%"
	elif [ "$PERC" -ge 80 ]; then
		printf " $PERC%%"
	elif [ "$PERC" -ge 60 ]; then
		printf " $PERC%%"
	elif [ "$PERC" -ge 40 ]; then
		printf " $PERC%%"
	elif [ "$PERC" -ge 20 ]; then
		printf " $PERC%%"
	else
		printf "%%{F$RED}%%{F-} $PERC%%"
		notify-send "Low battery" -a "ignorehistory" -u critical -r 9998
	fi
fi
