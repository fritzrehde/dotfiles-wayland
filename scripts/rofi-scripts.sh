#!/bin/sh

SCRIPTS=$(
	cat <<-END
	fzf-nvim scripts
	startup
	vpn
	download-clipboard
	tum-live-download
	lecturio-download
	git-dotfiles
	sys-info
	color-picker
	webcam-preview
	amphetamine
	pacman-update
	change-theme
	do-not-disturb
	new-script
	window-name
	rofi-pass
	mirror-output
	sway-move-workspaces-to-output
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
		# try executing as shell script, otherwise as python script, otherwise fail
		EXE="$(which ${CMD}.sh)" || "$(which ${CMD}.py)" || exit 1
		eval "$EXE"
		;;
esac
