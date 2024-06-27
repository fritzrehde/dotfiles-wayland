#!/bin/sh

SCRIPTS=$(
	cat <<-END
	tmux-fzf-nvim.sh scripts
	startup.sh
	vpn.sh toggle
	download-clipboard.sh
	tum-live-download.sh
	lecturio-download.sh
	git-dotfiles.sh
	color-picker.sh
	webcam-preview.sh
	amphetamine.sh
	pacman-update.sh
	change-theme.sh toggle
	do-not-disturb.sh
	new-script.sh
	mirror-output.sh
	sway-cursor.sh show
	sway-cursor.sh hide
	sway-move-workspaces-to-output.py
	screenrecording.sh toggle
	wifi.sh desktop
	unsw-desk-reservation.py
	END
)

CMD=$(echo "$SCRIPTS" | rofi.sh default)
eval "$CMD"
