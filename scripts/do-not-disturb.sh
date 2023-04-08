#!/bin/sh

case "$1" in
	icon)
		[ "$(dunstctl is-paused)" = "true" ] \
			&& printf ""
		;;
	*)
		case "$(dunstctl is-paused)" in
			false) dunstctl set-paused true ;;
			true) dunstctl set-paused false ;;
		esac
		polybar-reload.sh do_not_disturb
		;;
esac
