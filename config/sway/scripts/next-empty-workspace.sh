#!/bin/sh

# determine the next empty workspace in sway

non_empty_ws="$(swaymsg -t get_workspaces | jq -r '.[] | select(.representation) | .num')"

# TODO: optimize
for ws in $(seq 1 10); do
	if ! echo "$non_empty_ws" | grep -q "$ws"; then
		printf "%s" "$ws"
		exit 0
	fi
done

echo "No empty workspaces found" 1>&2
exit 1
