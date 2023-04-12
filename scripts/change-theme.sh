#!/bin/sh

# determine new theme
OLD_THEME="$(theme.sh)"
case "$1" in
	reload)
		NEW_THEME="$OLD_THEME"
		;;
	toggle)
		if [ "$OLD_THEME" = "dark" ]; then
			NEW_THEME="light"
		else
			NEW_THEME="dark"
		fi
		;;
	dark|light)
		NEW_THEME="$1"
		;;
	*)
		echo "Usage: $(basename $0) [reload|toggle|dark|light]"
		exit 1
		;;
esac
theme.sh "$NEW_THEME"

# unlink old and link new config file
relink() {
	# TODO: remove $2
	# FROM="$1"
	# TO="$(echo "$1" | sed 's/-$NEW_THEME//')"
	ln -fs ~/.config/$1 ~/.config/$2
}
relink qutebrowser/colors-${NEW_THEME}.py qutebrowser/colors.py
relink nvim/colors/nord-${NEW_THEME}.vim nvim/colors/nord.vim
relink nvim/statusline-${NEW_THEME}.vim nvim/statusline.vim
relink kitty/themes/${NEW_THEME}.conf kitty/themes/current.conf
relink tmux/tmux-${NEW_THEME}.conf tmux/tmux.conf
# relink polybar/colors-${NEW_THEME}.ini polybar/colors.ini
relink dunst/dunstrc-${NEW_THEME} dunst/dunstrc
relink gtk-3.0/settings-${NEW_THEME}.ini gtk-3.0/settings.ini
relink joshuto/theme-${NEW_THEME}.toml joshuto/theme.toml
relink wallpaper/macos-mojave-${NEW_THEME}.jpg wallpaper/wallpaper.jpg
for MODE in default top bottom icons power; do
	relink rofi/themes/${MODE}-${NEW_THEME}.rasi rofi/themes/${MODE}.rasi
done

# === reload apps
# river
$XDG_CONFIG_HOME/river/settings

# qutebrowser
if pgrep qutebrowser > /dev/null; then
	# bspc rule -a qutebrowser --one-shot desktop=1
	qutebrowser ":restart" &
fi

# swaybg
PID="$(pidof swaybg)"
swaybg -i $XDG_CONFIG_HOME/wallpaper/wallpaper.jpg &
kill "$PID"

# kitty
kitty +kitten themes --reload-in=all Current &

# nvim
nvim-ctl.sh "<esc>:colorscheme nord | source ~/.config/nvim/statusline.vim<cr>" &

# tmux
tmux source-file ~/.config/tmux/tmux.conf &

# funst
dunst.sh &
