#!/bin/sh

suspend=" Suspend"
lock=" Lock"
display_power="󰚥 Display Power"
reboot=" Reboot"
hibernate=" Hibernate"
shutdown=" Shutdown"

case "$(printf '%s\n' "$display_power" "$suspend" "$lock" "$reboot" "$hibernate" "$shutdown" | rofi.sh power -i)" in
	"$lock")
		swayidle \
			timeout 1 'swaymsg output \* dpms off' \
			resume    'swaymsg output \* dpms on' \
			&

		# lock screen and wait for it to be unlocked
		waylock -init-color 0x000000 -input-color 0x000000

		# terminate swayidle and clean up PID
		kill -TERM "$!"
		wait
		;;
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
