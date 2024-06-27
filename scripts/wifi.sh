#!/bin/sh

selected_ssid() {
	printf "$line" | cut -d ":" -f 1
}

case "$1" in
	list)
		NMCLI_FIELDS="SSID,IN-USE,BARS,SIGNAL,RATE,SECURITY"

		# The separator used by `nmcli --terse`
		SEP=':'

		# Print header
		echo "$NMCLI_FIELDS" | sed "s/,/${SEP}/g"

		# TODO: enable nmcli --colors "yes", but that interferes with awk filtering
		# Query Wi-Fi networks, deduplicate SSIDs (always keep IN-USE, otherwise only keep first), remove empty SSIDs, and sort by SIGNAL descendingly
		nmcli --terse --fields "$NMCLI_FIELDS" device wifi list \
			| awk -F':' '{
					seen[$1]++

					if ($2 == "*") {
						inuse[$1] = $0;
					} else {
						if (seen[$1] == 1 && $1 != "") other[$1] = $0;
					}
				}
				END {
					for (ssid in inuse) print inuse[ssid];
					for (ssid in other) if (!inuse[ssid]) print other[ssid];
				}' \
			| sort --field-separator="${SEP}" --key="4,4nr"
		;;
	connect)
		SSID=$(selected_ssid)
		if nmcli connection up "$SSID"; then
			notify-send "Connected \"$SSID\""
		else
			if nmcli device wifi connect "$SSID" password "$(rofi.sh top -p password)"; then
				notify-send "Connected \"$SSID\""
			else
				notify-send "Failed to connect to \"$SSID\""
			fi
		fi
		;;
	disconnect)
		SSID=$(selected_ssid)
		if nmcli connection down "$SSID"; then
			notify-send "Disconnected \"$SSID\""
		else
			notify-send "Failed to disconnect from \"$SSID\""
		fi
		;;
	desktop)
		# Open as "desktop" app (i.e. in new terminal)
		$TERMINAL -e "$0"
		;;
	*)
		watchbind -c $XDG_CONFIG_HOME/watchbind/wifi.toml
		;;
esac
