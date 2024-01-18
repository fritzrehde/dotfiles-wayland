#!/bin/sh

# Select files and/or directories in new terminal window `fzf` and return selected files.

fd_args="--no-ignore --absolute-path"
file_extensions="$2"

case "$1" in
	"files")
		fd_cmd="fd $fd_args --type file $file_extensions"
		;;
	"dirs")
		fd_cmd="fd $fd_args --type directory $file_extensions"
		;;
	"files-dirs")
		# We can't apply $file_extensions to directories, as no directories contains extensions
		fd_cmd="(fd $fd_args --type directory; fd $fd_args --type file $file_extensions) | sort"
		;;
	*)
		echo "Usage: $(basename $0) [files|dirs|files-dirs]" 1>&2
		exit 1
		;;
esac


# Create a tempfile to capture stdout
stdout_file="$(mktemp "/tmp/XXXXXX")"

# TODO: support "--class floating_wide" with sway to make this a floating window
alacritty --command sh -c "$fd_cmd | fzf.sh -d '/' --with-nth 4.. > $stdout_file"

stdout="$(cat "$stdout_file")"
rm -f "$stdout_file"

[ -n "$stdout" ] && echo "$stdout"
