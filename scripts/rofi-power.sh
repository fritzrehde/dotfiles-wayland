#!/bin/sh

suspend=" Suspend"
lock=" Lock"
display_power="󰚥 Displays ($(sway-display-power.py status))"
reboot=" Reboot"
hibernate=" Hibernate"
shutdown=" Shutdown"
night_shift="󰖨 Night Shift (state: $(night-shift.sh state))"

case "$(printf '%s\n' "$suspend" "$display_power" "$night_shift" "$lock" "$reboot" "$hibernate" "$shutdown" | rofi.sh power -i)" in
	"$lock") lock-screen.sh --turn-off-display ;;
	"$suspend") systemctl suspend ;;
	"$display_power") sway-display-power.py toggle ;;
	"$reboot") reboot ;;
	"$hibernate") systemctl hibernate ;;
	"$shutdown") shutdown now ;;
	"$night_shift") night-shift.sh toggle ;;
	*) exit 1 ;;
esac
