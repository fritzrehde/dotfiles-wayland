#!/bin/sh

OPTS=$(
	cat <<-END
	 Lock
	 Suspend
	 Reboot
	 Hibernate
	 Shutdown
	END
)

case "$(echo "$OPTS" | rofi.sh power -i)" in
	" Lock")
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
	" Suspend") systemctl suspend ;;
	" Reboot") reboot ;;
	" Hibernate") systemctl hibernate ;;
	" Shutdown") shutdown now ;;
	*) exit 1 ;;
esac
