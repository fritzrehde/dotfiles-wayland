#!/bin/sh

suspend=" Suspend"
lock=" Lock"
display_power="󰚥 Display Power"
reboot=" Reboot"
hibernate=" Hibernate"
shutdown=" Shutdown"

case "$(printf '%s\n' "$suspend" "$display_power" "$lock" "$reboot" "$hibernate" "$shutdown" | rofi.sh power -i)" in
	"$lock") lock-screen.sh --turn-off-display ;;
	"$suspend") systemctl suspend ;;
	"$display_power")
		swaymsg -t get_outputs | jq -r '.[].name' \
			| rofi.sh top \
			| xargs -I {} swaymsg "output {} power toggle"
		;;
	"$reboot") reboot ;;
	"$hibernate") systemctl hibernate ;;
	"$shutdown") shutdown now ;;
	*) exit 1 ;;
esac
