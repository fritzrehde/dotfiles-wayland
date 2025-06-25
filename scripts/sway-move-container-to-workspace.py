#!/usr/bin/env python3

# Move focused container to specified workspace, but if desired workspace is already focused, move focused workspace to next output

import argparse
import json
import subprocess
import sys


def get_focused_workspace():
    """Returns the number of the currently focused workspace."""
    workspaces = json.loads(subprocess.run(["swaymsg", "-t", "get_workspaces"], capture_output=True, text=True).stdout)
    return next((ws["num"] for ws in workspaces if ws["focused"]), None)


def move_container_to_workspace(desired_ws):
    """Moves the focused container to the desired workspace."""
    subprocess.run(["swaymsg", f"move container to workspace number {desired_ws}; workspace number {desired_ws}"])


def move_workspace_to_next_output():
    """Moves the focused workspace to the next output."""
    outputs = json.loads(subprocess.run(["swaymsg", "-t", "get_outputs"], capture_output=True, text=True).stdout)
    focused_output_index = next((i for i, output in enumerate(outputs) if output['focused']), None)
    if focused_output_index is None:
        print("Error: expected there to be exactly one focused output, but there were none.", file=sys.stderr)
        sys.exit(1)

    next_output_index = (focused_output_index + 1) % len(outputs)
    if next_output_index == focused_output_index:
        print("Nothing to do, as only one output is connected.", file=sys.stderr)
        sys.exit(0)
    next_output = outputs[next_output_index]['name']

    subprocess.run(["swaymsg", f"move workspace to {next_output}"])


def main():
    parser = argparse.ArgumentParser(description='Move focused container to workspace, but if desired workspace is already focused, move focused workspace to next output')
    parser.add_argument('desired_ws', type=int, help='the desired workspace number')
    args = parser.parse_args()

    focused_ws = get_focused_workspace()
    if focused_ws is None:
        print("Error: expected there to be exactly one focused workspace, but there were none.", file=sys.stderr)
        sys.exit(1)

    if args.desired_ws == focused_ws:
        move_workspace_to_next_output()
    else:
        move_container_to_workspace(args.desired_ws)


if __name__ == "__main__":
    main()
