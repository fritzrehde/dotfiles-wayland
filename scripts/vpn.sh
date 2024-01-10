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
		if nmcli connection up "$VPN"; then
			notify-send "${VPN} connected"

			# Notify waybar
			pkill -RTMIN+6 waybar
		fi
		;;
	disconnect|d)
		if nmcli connection down "$VPN"; then
			notify-send "${VPN} disconnected"

			# Notify waybar
			pkill -RTMIN+6 waybar
		fi
		;;
	status|s)
		# TODO
		# nordvpn status
		;;
	*)
		echo "Usage: $(basename $0) [toggle|connect|disconnect|status]"
esac
