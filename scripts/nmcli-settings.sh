#!/bin/sh

# networkmanager settings to prefer using ethernet over wifi

if [ $# -ne 2 ]; then
	echo "Usage: $(basename $0) <ETH> <WIFI>" 1>&2
	exit 1
fi

ETH="$1"
WIFI="$2"

# check if names exist
for CONNECTION in "$ETH" "$WIFI"; do
	nmcli connection show \
		| tail -n +2 | awk '{ print $1 }' FS="  " \
		| grep -qx "$CONNECTION" \
		|| { echo "Error: unknown connection names" 1>&2; exit 1; }
done

# lower is more preferred; default is -1
nmcli connection modify "$ETH" ipv4.route-metric 10
nmcli connection modify "$ETH" ipv6.route-metric 10
nmcli connection modify "$WIFI" ipv4.route-metric 20
nmcli connection modify "$WIFI" ipv6.route-metric 20

# disconnect and reconnect to update settings
for CONNECTION in "$ETH" "$WIFI"; do
	nmcli connection down "$CONNECTION"
	nmcli connection up "$CONNECTION"
done
