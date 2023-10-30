#!/bin/sh

VPN="nordvpn"

case "$1" in
	toggle|t)
		if nmcli connection show --active | grep -q "$VPN"; then
			$0 disconnect
		else
			$0 connect
		fi
		;;
	connect|c)
		nmcli connection up "$VPN" \
			&& notify-send "${VPN} connected"
		;;
	disconnect|d)
		nmcli connection down "$VPN" \
			&& notify-send "${VPN} disconnected"
		;;
	status|s)
		# nordvpn status
		;;
	*)
		echo "Usage: $(basename $0) [toggle|connect|disconnect|status]"
esac
