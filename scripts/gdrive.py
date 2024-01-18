#!/usr/bin/env python3

# TODO: extra features to implement:
# - sort by different things: alphabetical, file-size
# - mkdir command, get node's name from text input (maybe use rofi until text input watchbind feature is implemented)
# - display uploads in UI as well, and make them cancellable with keybinding

from argparse import ArgumentParser
import subprocess
import json
import os
from typing import List, Tuple, Optional

# Binary dependencies: watchbind, rclone, numfmt

# === System-specific config values and functions (override these with your own)

# Larger -> higher performance, higher memory usage.
DRIVE_CHUNK_SIZE = "1024M"

# Only show files with these file extensions when selecting files.
UPLOADABLE_FILE_EXTENSIONS = os.environ.get(
    "GDRIVE_UPLOADABLE_FILE_EXTENSIONS")


def select_files() -> List[str]:
    """Interactively select files from the file system."""
    result = subprocess.run(["fileselect.sh", "files-dirs", *([UPLOADABLE_FILE_EXTENSIONS] if UPLOADABLE_FILE_EXTENSIONS else [])],
                            capture_output=True, text=True)
    return result.stdout.splitlines()

# ===


cli = ArgumentParser()
subparsers = cli.add_subparsers(dest="subcommand")


def subcommand():
    """Turn a function into a cli subcommand (with no args)."""
    def decorator(func):
        parser = subparsers.add_parser(
            func.__name__, description=func.__doc__, help=func.__doc__)
        parser.set_defaults(func=func)
    return decorator


def get_selected_line():
    return os.environ.get("line")


def get_selected_lines():
    return os.environ.get("lines", "").splitlines()


def get_pwd() -> str:
    return os.environ.get("pwd", "")


def get_parent_pwd(pwd: str) -> str:
    """Given the pwd (e.g. `a/b/c`), return the parent pwd (e.g. `a/b`)"""
    # Split on rightmost '/', and keep everything left of it.
    return pwd.rpartition('/')[0]


def get_total_size() -> str:
    return os.environ.get("total_size", "unknown")


def numfmt(bytes: int, padding: int = None) -> str:
    """Return a size in bytes in human-readable form."""
    if bytes < 0:
        return ""

    numfmt_cmd = [
        "numfmt", "--to=iec", "--suffix=B",
        *([f"--padding={padding}"] if padding is not None else []),
        f"{bytes}"
    ]
    result = subprocess.run(numfmt_cmd, capture_output=True, text=True)
    return result.stdout.rstrip()


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


@subcommand()
def delete_nodes():
    """Delete all selected nodes (files and/or directories)."""
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


def send_progress_notification(title, percentage, size, speed, id):
    notify_send_cmd = ["notify-send", f"Upload {percentage}% at {numfmt(speed)}/s of {numfmt(size)}",
                       title, f"--replace-id={id}", f"--hint=int:value:{percentage}", "--expire-time=0"]
    subprocess.run(notify_send_cmd)


def request_notification_id() -> str:
    return subprocess.run(["notify-id.sh", "lock"], text=True, capture_output=True).stdout.strip()


def drop_notification_ids(ids: dict):
    for id in ids.values():
        subprocess.run(["notify-id.sh", "unlock", id])


# TODO: turn into method on hashmap directly
def get_or_insert(hashmap: dict, key, eval_other):
    """Return `hashmap[key]`, and set value to `eval_other()` if it does not yet exist."""
    if key not in hashmap:
        hashmap[key] = eval_other()
    return hashmap[key]


def parse_transfer_stats(log_line: str, notification_ids: dict):
    log = json.loads(log_line)

    def parse_transfer_stat(stat):
        title = stat["name"]
        percentage = stat["percentage"]
        size = stat["size"]
        # Current speed, not average ("speedAvg" name is very misleading)
        speed = stat["speedAvg"]
        id = get_or_insert(notification_ids, title, request_notification_id)
        return title, percentage, size, speed, id

    try:
        return [parse_transfer_stat(stat) for stat in log["stats"]["transferring"]]
    except KeyError:
        return []


@subcommand()
def upload_nodes():
    """Upload nodes (files and/or directories) that are selected via external script."""
    pwd = get_pwd()

    for node_to_be_uploaded in select_files():
        notification_ids = {}
        rclone_upload_cmd = ["rclone", "copy", node_to_be_uploaded,
                             f"gdrive:{pwd}", f"--drive-chunk-size={DRIVE_CHUNK_SIZE}",
                             "--log-level=INFO", "--use-json-log", "--stats=1s"]
        try:
            with subprocess.Popen(rclone_upload_cmd, stderr=subprocess.PIPE, text=True, bufsize=1, universal_newlines=True) as proc:
                for log_line in proc.stderr:
                    print(log_line)
                    for title, percentage, size, speed, id in parse_transfer_stats(log_line, notification_ids):
                        send_progress_notification(
                            title, percentage, size, speed, id)
        finally:
            drop_notification_ids(notification_ids)


@subcommand()
def enter_dir():
    """Set $pwd to $pwd/selected_dir."""
    pwd = get_pwd()
    if (node := get_selected_node()) is not None:
        dir_name, _, is_dir = node
        if is_dir:
            pwd = path_join(pwd, dir_name)
    print(pwd, end="")


@subcommand()
def exit_dir():
    """Set $pwd to its parent dir."""
    print(get_parent_pwd(get_pwd()), end="")


@subcommand()
def total_size():
    """Set $total_size to the total size of all documents that are recursively in the current directory."""
    pwd = get_pwd()
    json_output = subprocess.run(
        ["rclone", "size", f"gdrive:{pwd}", "--json"], capture_output=True, text=True).stdout
    size = json.loads(json_output)
    print(numfmt(size["bytes"]), end="")


def list_nodes_in_pwd(pwd: str) -> str:
    """Lists (only/non-recursively) all notes (files and subdirectories) in the the current directory."""
    json_output = subprocess.run(
        ["rclone", "lsjson", f"gdrive:{pwd}"], capture_output=True, text=True).stdout
    nodes = json.loads(json_output)
    list = [
        f'{node["Name"]},{numfmt(node["Size"], 6)},{node["IsDir"]}' for node in nodes]
    return "\n".join(list)


@subcommand()
def print_ui():
    """Print the textual UI containing info lines (pwd, size), the column names and the nodes (files and directories)."""
    pwd = get_pwd()

    pwd_ = f"pwd: /{pwd}"
    total_size = f"size: {get_total_size()}"
    header = "NAME,SIZE"
    list = list_nodes_in_pwd(pwd)

    print("\n".join([pwd_, total_size, header, list]))


# # TODO: temporary until new watchbind version is released
# if (home := os.environ.get("HOME")) is not None:
#     watchbind_binary = os.path.join(
#         home, "code/watchbind/target/release/watchbind")


def main():
    args = cli.parse_args()

    if args.subcommand:
        # Execute subcommand:
        args.func()
    else:
        # Launch `watchbind` when no subcommand is provided.
        # TODO: make customizable so others can easily use this script as well
        if (xdg_config_home := os.environ.get("XDG_CONFIG_HOME")) is not None:
            subprocess.run(["watchbind", "--config-file",
                            f"{xdg_config_home}/watchbind/gdrive.toml"])


if __name__ == "__main__":
    main()
