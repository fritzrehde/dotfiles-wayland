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


import subprocess
import sys
import json
import os


def get_selected_line():
    return os.environ.get("line")

# TODO: optimize with list comprehension
def get_selected_files():
    lines = os.environ.get("lines", "").split("\n")
    result = []

    for line in lines:
        if line:
            split = line.split(",")
            result.append((split[0], split[2]))

    return result


def delete_files():
    """"Delete/purge all selected files and/or directories."""
    # TODO: do in parallel
    for file, is_dir in get_selected_files():
        if is_dir:
            subprocess.run(["rclone", "purge", f"gdrive:{file}"])
        else:
            subprocess.run(["rclone", "delete", f"gdrive:{file}"])


def enter_dir():
    pwd = os.environ.get("pwd")
    if (line := get_selected_line()) is not None:
        split = line.split(",")
        is_dir = split[2]
        if is_dir:
            dir = split[0]
            return os.path.join(pwd, dir)
    
    return pwd


# TODO: also show the recursive size of each directory (currently it's -1)
def list_cur_dir():
    """Lists (only/non-recursively) all files and subdirectories in the the current directory."""
    pwd = os.environ.get("pwd", "")
    json_output = subprocess.run(["rclone", "lsjson", f"gdrive:{pwd}"], capture_output=True, text=True).stdout
    try:
        files = json.loads(json_output)
    except Exception:
        print(f"""
        Error: parsing the output into JSON failed.
        output:
        {json}
        """, file=sys.stderr)
        exit(1)

    print_str = "NAME,SIZE,IS_DIRECTORY\n"

    # TODO: do shorter with list comprehension
    # Includes both files and directories
    for file in files:
        name = file["Name"]
        size = file["Size"]
        is_dir = file["IsDir"]

        print_str += f"{name},{size},{is_dir}\n"

    print(print_str, end="")


# TODO: temporary until new watchbind version is released
if (home := os.environ.get("HOME")) is not None:
    watchbind_binary = os.path.join(home, "code/watchbind/target/release/watchbind")

def main():
    # TODO: find more clean/modern/functional solution
    match len(sys.argv):
        case 1:
            if (xdg_config_home := os.environ.get("XDG_CONFIG_HOME")) is not None:
                subprocess.run([watchbind_binary, "--config-file", f"{xdg_config_home}/watchbind/gdrive.toml"])
        case 2:
            sub_command = sys.argv[1]
            match sub_command:
                case "list":
                    list_cur_dir()
                case "delete":
                    delete_files()
                case "upload":
                    upload_file_or_dir()
                case "download":
                    download_file_or_dir()
                case "enter-dir":
                    enter_dir()
                case "exit-dir":
                    exit_dir()
                case _:
                    print("Error: unknown command: {sub_command}", file=sys.stderr)
                    exit(1)


if __name__ == "__main__":
    main()
