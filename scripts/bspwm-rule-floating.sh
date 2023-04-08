#!/bin/sh

RESOLUTION=$(xrandr | grep "*" | awk '{ print $1 }')
WIDTH=$(echo "$RESOLUTION" | cut -d "x" -f 1)
HEIGHT=$(echo "$RESOLUTION" | cut -d "x" -f 2)
# echo "SCREEN: ${WIDTH}x${HEIGHT}"

add_rule() {
	RULE_NAME="$1"
	W_PERC="$2"
	H_PERC="$3"
	W=$(echo "scale=0; (${WIDTH}*${W_PERC})/100" | bc)
	H=$(echo "scale=0; (${HEIGHT}*${H_PERC})/100" | bc)
	X=$(echo "scale=0; (${WIDTH}-${W})/2" | bc)
	Y=$(echo "scale=0; (${HEIGHT}-${H})/2" | bc)

	bspc rule -a "$RULE_NAME" state=floating focus=on rectangle=${W}x${H}+${X}+${Y}
	# echo "$RULE_NAME: ${W}x${H}+${X}+${Y}"
}

add_rule "floating_tall" 45 90
add_rule "floating_wide" 70 90
