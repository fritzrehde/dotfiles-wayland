#!/usr/bin/env python

# Move all workspaces from one output to another output

import json
import subprocess
import sys


def get_outputs():
    """Returns a list of output names."""
    outputs = json.loads(subprocess.run(["swaymsg", "-t", "get_outputs"], capture_output=True, text=True).stdout)
    return [output["name"] for output in outputs]


def prompt_for_output(outputs, prompt):
    """Prompts the user to select an output and returns its name."""
    rofi = subprocess.run(["rofi.sh", "top", "-p", prompt], input="\n".join(outputs), capture_output=True, text=True)
    if rofi.returncode != 0:
        print("Nothing selected in rofi. Exiting.", file=sys.stderr)
        exit(0)

    selected_output = rofi.stdout.strip()
    if selected_output not in outputs:
        raise ValueError(f"Invalid output selected: {selected_output}")
    return selected_output


def move_workspaces(src_output, dst_output):
    """Moves all workspaces from the source output to the destination output."""
    workspaces = json.loads(subprocess.run(["swaymsg", "-t", "get_workspaces"], capture_output=True, text=True).stdout)
    workspaces = [ws for ws in workspaces if ws["output"] == src_output]
    swaymsg = ["swaymsg", ";".join([f'[workspace={ws["num"]}] move workspace to {dst_output}' for ws in workspaces])]
    subprocess.run(swaymsg)


def main():
    try:
        outputs = get_outputs()
        src_output = prompt_for_output(outputs, "src")
        dst_output = prompt_for_output(outputs, "dst")
        move_workspaces(src_output, dst_output)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
