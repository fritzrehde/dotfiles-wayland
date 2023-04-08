#!/bin/sh

login() {
	if ! nordvpn account > /dev/null; then
		TOKEN="$(pass nordvpn.com/token)"
		nordvpn login --token "$TOKEN"
	fi
}

case "$1" in
	icon)
		nordvpn status | grep -q "Status: Connected" \
			&& printf "ﱾ"
		;;
	toggle|t)
		if nordvpn status | grep -q "Connected"; then
			vpn.sh disconnect
		else
			vpn.sh connect
		fi
		;;
	connect|c)
		login
		nordvpn connect && polybar-reload.sh vpn
		;;
	disconnect|d)
		nordvpn disconnect && polybar-reload.sh vpn
		;;
	status|s)
		nordvpn status
		;;
	*)
		echo "Usage: $(basename $0) [toggle|connect|disconnect|status]"
esac
