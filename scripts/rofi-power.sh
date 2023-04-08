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
		sleep 0.05
		xset dpms force off
		;;
	" Suspend") systemctl suspend ;;
	" Reboot") reboot ;;
	" Hibernate") systemctl hibernate ;;
	" Shutdown") shutdown now ;;
	*) exit 1 ;;
esac
