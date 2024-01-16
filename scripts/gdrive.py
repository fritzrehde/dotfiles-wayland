#!/usr/bin/env python

# file_ids() {
# 	echo "$LINES" | awk '{ print $1 }' FS="   "
# }

# upload() {
# 	FILE="$1"
# 	ID="$(notify-id.sh lock)"
# 	TITLE="$(basename "$FILE")"
# 	IFS=',' # for read while loop
# 	stdbuf -oL gdrive upload -r "$FILE" 2>&1 \
# 		| stdbuf -i0 -oL tr '\r' '\n' \
# 		| grep --line-buffered -e "[^[:blank:]].*Rate:" \
# 		| stdbuf -i0 -oL sed -e 's/ //g' -e 's/\//,/' -e 's/,Rate:/,/' -e 's/B//g' -e 's/\/s//' \
# 		| stdbuf -i0 -oL numfmt -d "," --field=- --from=auto \
# 		| stdbuf -i0 -oL awk '{ printf "%02d,%.1f MB/s,%d MB\n", $1*100/$2, $3/1000000, $2/1000000 }' FS="," \
# 		| while read PERC SPEED SIZE; do
# 		notify-send "Upload ${PERC}% at ${SPEED} of ${SIZE}" "$TITLE" -r "$ID" -h "int:value:${PERC}" -t 0
# 	done
# 	notify-id.sh unlock "$ID"
# }

# case "$1" in
# 	list)
# 		gdrive list --no-header --name-width 0 --order name --max 500 \
# 			| grep bin \
# 			| sed 's/   */,/g' \
# 			| cut -f 1,2,4 -d "," --output-delimiter "," \
# 			| column -t -s "," -o "   "
# 		;;
# 	delete)
# 		# file_ids | parallel 'gdrive3 files delete "{}"'
# 		file_ids | parallel 'gdrive delete "{}"'
# 		;;
# 	download)
# 		# TODO: do in parallel or all at once!
# 		file_ids | xargs -I {} gdrive download "{}"
# 		;;
# 	upload)
# 		fileselect.sh "-e mp4 -e mkv -e webm" | while read FILE; do
# 			upload "$FILE" &
# 		done
# 		;;
# 	space-used)
# 		BYTES_SUM=$(
# 			gdrive list --no-header --name-width 0 --order name --max 500 --bytes \
# 				| grep bin \
# 				| sed 's/   */,/g' \
# 				| cut -d "," -f 4 --output-delimiter "," \
# 				| tr -dc '0-9,\n' \
# 				| tr '\n' '+'
# 		)
# 		# "...+0"
# 		SPACE_USED="$(echo "${BYTES_SUM}0" | bc | numfmt --to=si --format="%.2f")"
# 		notify-send "gdrive: space used" "$SPACE_USED"
# 		;;
# 	*)
# 		watchbind --config-file ~/dotfiles/config/watchbind/gdrive.toml
# 		;;
# esac


# TODO: cool extra features to support:
# - sort by different things: alphabetical, file-size
# - mkdir command, get node's name from text input
# - display file-size nicely, not in fixed unit, but in nicest to display in specified number of digits (e.g. 4)

import subprocess
import sys
import json
import os
from typing import List, Tuple, Optional


def numfmt(bytes: int, padding: int = None) -> str:
    if bytes < 0:
        return ""

    numfmt_cmd = [
        "numfmt", "--to=iec", "--suffix=B",
        *([f"--padding={padding}"] if padding is not None else []),
        f"{bytes}"
    ]
    result = subprocess.run(numfmt_cmd, capture_output=True, text=True)
    return result.stdout.rstrip()


def get_selected_line():
    return os.environ.get("line")


def get_selected_lines():
    return os.environ.get("lines", "").split("\n")


def parse_node(line: str) -> Tuple[str, int, bool]:
    """Parse a node (file or directory) from a string line."""
    # line with node's attributes: "NAME,SIZE,IS_DIRECTORY"
    node_name, size, is_dir = line.split(",")
    # TODO: unclean parsing of bool from string
    return node_name, size, (is_dir == "True")


def get_selected_node() -> Optional[Tuple[str, int, bool]]:
    # TODO: cleaner syntax like in Rust: Option.map(|line| parse_node(line))
    if (line := get_selected_line()) is not None:
        return parse_node(line)
    else:
        return None


def get_selected_nodes() -> List[Tuple[str, int, bool]]:
    return [parse_node(line) for line in get_selected_lines() if line]


def path_join(path_a, path_b):
    """Join two gdrive paths."""
    # TODO: it's not a real path, so maybe that causes problems
    return os.path.join(path_a, path_b)


def delete_nodes():
    """"Delete all selected nodes (files and/or directories)."""
    pwd = get_pwd()

    files, dirs = [], []
    for node_name, _, is_dir in get_selected_nodes():
        (dirs if is_dir else files).append(path_join(pwd, node_name))

    if files != []:
        # Delete files in bulk with single rclone command
        subprocess.run(["rclone", "delete", f"gdrive:", "--files-from=-",
                        "--drive-use-trash=false"], input="\n".join(files), text=True)

    # TODO: find a way to delete directories in bulk with one rclone command as well
    # Delete directories
    for dir_path in dirs:
        subprocess.run(
            ["rclone", "purge", f"gdrive:{dir_path}", "--drive-use-trash=false"])


def get_pwd() -> str:
    return os.environ.get("pwd", "")


def get_parent_pwd(pwd: str) -> str:
    """Given the pwd (e.g. `a/b/c`), return the parent pwd (e.g. `a/b`)"""
    # Split on rightmost '/', and keep everything left of it.
    return pwd.rpartition('/')[0]


def get_total_size() -> str:
    return os.environ.get("total_size", "unknown")


def enter_dir():
    """Set $pwd to $pwd/selected_dir."""
    pwd = get_pwd()
    if (node := get_selected_node()) is not None:
        dir_name, _, is_dir = node
        if is_dir:
            pwd = path_join(pwd, dir_name)
    print(pwd, end="")


def exit_dir():
    """Set $pwd to its parent dir."""
    print(get_parent_pwd(get_pwd()), end="")


def total_size():
    """Set $total_size to the total size of all documents in gdrive."""
    pwd = get_pwd()
    json_output = subprocess.run(
        ["rclone", "size", f"gdrive:{pwd}", "--json"], capture_output=True, text=True).stdout
    try:
        size = json.loads(json_output)
    except Exception:
        print(
            f"Error: parsing rclone's output into JSON failed.\noutput:\n{json_output}", file=sys.stderr)
        exit(1)

    print(numfmt(size["bytes"]), end="")


# TODO: also show the recursive size of each directory (currently it's -1)
def list_nodes_in_pwd(pwd: str) -> str:
    """Lists (only/non-recursively) all notes (files and subdirectories) in the the current directory."""

    json_output = subprocess.run(
        ["rclone", "lsjson", f"gdrive:{pwd}"], capture_output=True, text=True).stdout
    try:
        nodes = json.loads(json_output)
    except Exception:
        print(
            f"Error: parsing rclone's output into JSON failed.\noutput:\n{json_output}", file=sys.stderr)
        exit(1)

    list = [
        f'{node["Name"]},{numfmt(node["Size"], 6)},{node["IsDir"]}' for node in nodes]
    return "\n".join(list)


def print_ui():
    pwd = get_pwd()

    pwd_ = f"pwd: /{pwd}"
    total_size = f"size: {get_total_size()}"
    header = "NAME,SIZE,IS_DIRECTORY"
    list = list_nodes_in_pwd(pwd)

    print("\n".join([pwd_, total_size, header, list]))


# # TODO: temporary until new watchbind version is released
# if (home := os.environ.get("HOME")) is not None:
#     watchbind_binary = os.path.join(
#         home, "code/watchbind/target/release/watchbind")


def main():
    # TODO: find more clean/modern/functional solution for args parsing
    match len(sys.argv):
        case 1:
            if (xdg_config_home := os.environ.get("XDG_CONFIG_HOME")) is not None:
                subprocess.run(["watchbind", "--config-file",
                                f"{xdg_config_home}/watchbind/gdrive.toml"])
        case 2:
            sub_command = sys.argv[1]
            match sub_command:
                case "print-ui":
                    print_ui()
                case "delete":
                    delete_nodes()
                case "upload":
                    upload_node()
                case "download":
                    download_node()
                case "enter-dir":
                    enter_dir()
                case "exit-dir":
                    exit_dir()
                case "total-size":
                    total_size()
                case _:
                    print(
                        "Error: unknown command: {sub_command}", file=sys.stderr)
                    exit(1)


if __name__ == "__main__":
    main()
