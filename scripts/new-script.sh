#!/bin/sh

# Create a new script

SCRIPTS=$HOME/git/dotfiles-wayland/scripts
FILENAME="$(rofi.sh top -p "name")" || exit 1

# make sure that extension shell or python extension is provided
case "$FILENAME" in
	*.sh | *.py) ;;
	*)
		echo "File name must be a shell (*.sh) or python (*.py) script." 1>&2
		exit 1
		;;
esac

# create file
FILE=$SCRIPTS/$FILENAME
touch "$FILE"
chmod +x "$FILE"

# link file
LINK_TO=~/.local/bin/$FILENAME
ln -fs "$FILE" "$LINK_TO"

# add shebang to file
case "$FILENAME" in
	*.sh)
		printf "#!/bin/sh\n" > "$FILE"
		;;
	*.py)
		printf "#!/usr/bin/env python\n" > "$FILE"
		;;
esac
