#!/usr/bin/env python

import subprocess
import sys
import json
import os
from math import floor
from typing import Optional


def get_torrent_ids() -> Optional[str]:
    """Extract the id from each watchbind line and output all ids delimited by a ','."""
    if (watchbind_lines := os.environ.get("LINES")) is not None:
        return ','.join(line.split(',')[0] for line in watchbind_lines.split('\n'))
    else:
        return None


def transmission_exec_on_all(command):
    """Execute a transmission command on all selected watchbind lines."""
    if (torrent_ids := get_torrent_ids()) is not None:
        subprocess.run(["transmission-remote", "--torrent", torrent_ids, command])


def get_clipboard_content():
    # TODO: don't execute anything when clipboard is empty
    return subprocess.run(["clipboard.sh", "paste"], capture_output=True, text=True).stdout


def status_str(code):
    match code:
        case 0: return "stopped    "
        case 1: return "Q verify   "
        case 2: return "verifying  "
        case 3: return "Q download "
        case 4: return "downloading"
        case 5: return "Q seed     "
        case 6: return "seeding    "
        case _:
            print(f"Error: Invalid status code: {code}", file=sys.stderr)
            exit(1)


def add_torrent():
    if (torrent_link := get_clipboard_content()) is not None:
        subprocess.run(["transmission-remote", "--add", torrent_link])


def list_torrents():
    print_str = "ID,STATUS,BAR,PERC,DOWN,UP,NAME\n"
    output = subprocess.run(["transmission-remote", "--json", "--list"], capture_output=True, text=True).stdout
    try:
        torrents = json.loads(output)["arguments"]["torrents"]
    except Exception:
        print(f"""
        Error: parsing the output into JSON failed.
        output:
        {output}
        """, file=sys.stderr)
        exit(1)

    for torrent in torrents:
        # raw data parsed from json
        id = torrent["id"]
        name = torrent["name"]
        eta = torrent["eta"]
        size_left = torrent["leftUntilDone"]
        size_total = torrent["sizeWhenDone"]
        download = torrent["rateDownload"]
        upload = torrent["rateUpload"]
        status_code = torrent["status"]

        # transformed data
        status = status_str(status_code)
        percentage = floor(((size_total - size_left) * 100) / size_total)
        progress_bar = subprocess.run(['asciibar', '--min=0', '--max=100', '--length=10', '--border="|"', f'{percentage}'])
        download = f'{(download / 1000000):.1f} MB/s'
        upload = f'{(upload / 1000000):.1f} KB/s'

        print_str += f"{id},{status},{progress_bar},{percentage:3d}%,{download},{upload},{name}\n"

    print(print_str, end="")


def file_torrents():
    # TODO
    # ids = subprocess.check_output(["transmission-remote", "--list"]).decode("utf-8").strip().split("\n")
    # file_index = subprocess.run(["rofi.sh", "default", "-p", "file"], input='\n'.join(ids).encode("utf-8"), capture_output=True).stdout.decode("utf-8").strip()
    # subprocess.run(["transmission-remote", "--torrent", get_torrent_ids(), "--get", file_index])
    return


def main():
    match len(sys.argv):
        case 1:
            if (xdg_config_home := os.environ.get("XDG_CONFIG_HOME")) is not None:
                subprocess.run(["watchbind", "--config-file", f"{xdg_config_home}/watchbind/torrent.toml"])
        case 2:
            sub_command = sys.argv[1]
            match sub_command:
                case "list":
                    list_torrents()
                case "file":
                    file_torrents()
                case "add":
                    add_torrent()
                case "start":
                    transmission_exec_on_all("--start")
                case "stop":
                    transmission_exec_on_all("--stop")
                case "remove":
                    transmission_exec_on_all("--remove")
                case "delete":
                    transmission_exec_on_all("--remove-and-delete")
                case _:
                    print("Error: unknown command: {sub_command}", file=sys.stderr)
                    exit(1)


if __name__ == "__main__":
    main()
