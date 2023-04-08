#!/bin/sh

SCRIPTS=$(
	cat <<-END
	fzf-nvim scripts
	startup
	input-settings
	xrandr-monitor docked
	xrandr-monitor internal
	vpn
	download-clipboard
	tum-live-download
	lecturio-download
	git-dotfiles
	sys-info
	time
	color-picker
	webcam-preview
	amphetamine
	pacman-update
	change-theme
	do-not-disturb
	new-script
	window-name
	rofi-pass
	END
)

CMD=$(echo "$SCRIPTS" | rofi.sh default)
case "$CMD" in
	"fzf-nvim scripts")
		tmux display-popup -w 50% -h 60% -E "fzf-nvim.sh scripts"
		;;
	"xrandr-monitor docked")
		xrandr-monitor.sh docked
		;;
	"xrandr-monitor internal")
		xrandr-monitor.sh internal
		;;
	vpn)
		vpn.sh toggle
		;;
	change-theme)
		change-theme.sh toggle
		;;
	*)
		eval "$CMD.sh"
		;;
esac
