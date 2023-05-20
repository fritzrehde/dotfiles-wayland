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
	sway-cursor show
	sway-cursor hide
	sway-move-workspaces-to-output
	END
)

CMD=$(echo "$SCRIPTS" | rofi.sh default)
# TODO: remove having to specify this for each, just remove .sh or .py from all scripts
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
	"sway-cursor show")
		sway-cursor.sh show
		;;
	"sway-cursor hide")
		sway-cursor.sh hide
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
