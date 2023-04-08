#!/bin/sh

TZ=$(timedatectl --no-pager list-timezones | rofi.sh top -i -p timezone) || exit 1
notify-send "sudo"
sudo timedatectl set-timezone "$TZ" \
	&& notify-send "Timezone \"$TZ\""
