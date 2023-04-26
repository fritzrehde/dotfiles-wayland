#!/bin/sh

dotfiles_dir=$HOME/git/dotfiles-wayland

_git() {
	git -C "$dotfiles_dir" "$@"
}

COMMIT_MSG="$(rofi.sh top -p "commit-msg")" || exit 1
[ -z "$COMMIT_MSG" ] \
	&& COMMIT_MSG="Updated some dotfiles"

ADDED="$(_git add -A --dry-run)"
notify-send "dotfiles" "$ADDED"

rofi.sh top -p "continue?" > /dev/null || exit 1
_git add -A \
	&& _git commit -m "$COMMIT_MSG" \
	&& _git push
notify-send "dotfiles" "pushed"
