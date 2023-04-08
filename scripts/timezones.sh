#!/bin/sh

SYD=$(TZ=Australia/Sydney date +"%a, %d %b %H:%M")

INFO=$(
	cat <<-END
	SYD: $SYD
	END
)

dunstify "$INFO" -a "ignorehistory" -u low -r 9986
