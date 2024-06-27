#!/usr/bin/env python

# Change focus between multiple windows on current workspace, but if single window on current workspace, change focus to next output

import json
import subprocess
import sys


def multiple_windows_in_focused_workspace():
    """Returns whether the focused workspace contains multiple windows."""
    workspaces = json.loads(subprocess.run(["swaymsg", "-t", "get_workspaces"], capture_output=True, text=True).stdout)
    windows_on_focused_ws = next((ws["focus"] for ws in workspaces if ws["focused"]), None)
    if windows_on_focused_ws is None:
        print("Error: expected there to be exactly one focused workspace, but there were none.", file=sys.stderr)
        sys.exit(1)

    return len(windows_on_focused_ws) > 1


def focus_next_window():
    """Moves focus to the next (in right direction) window on the focused workspace."""
    subprocess.run(["swaymsg", "focus right"])


def focus_next_output():
    """Moves focus to the next output."""
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

    subprocess.run(["swaymsg", f"focus output {next_output}"])


def main():
    # if multiple_windows_in_focused_workspace():
    #     focus_next_window()
    # else:
    #     focus_next_output()
    focus_next_output()


if __name__ == "__main__":
    main()
