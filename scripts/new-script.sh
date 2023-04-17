#!/bin/sh

# create new shell script

SCRIPTS=$HOME/git/dotfiles-wayland/scripts
FILENAME="$(rofi.sh top -p "name")" || exit 1

# create file
FILE=$SCRIPTS/$FILENAME.sh
touch "$FILE"
chmod +x "$FILE"

# link file
LINK_TO=~/.local/bin/$FILENAME.sh
ln -fs "$FILE" "$LINK_TO"

# edit file
printf "#!/bin/sh\n" > "$FILE"
