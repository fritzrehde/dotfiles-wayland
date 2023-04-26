#!/usr/bin/env python

# Move all workspaces from one output to another output

import json
from subprocess import check_output, call

try:
    outputs = '\n'.join(check_output("swaymsg -t get_outputs | jq -r '.[] | .name'", shell=True).decode().splitlines())
    src_output, dst_output = (
        check_output(f"echo '{outputs}' | rofi.sh top -p {prompt}", shell=True).decode().splitlines()[0]
        for prompt in ['src', 'dst']
    )
except:
    print("Error: rofi failed for some reason.")
    exit(1)

workspaces = json.loads(check_output(["swaymsg", "-t", "get_workspaces"]))
workspaces = list(filter(lambda ws: ws["output"] == src_output, workspaces))

swaymsg = ["swaymsg", ';'.join([f'[workspace={ws["num"]}] move workspace to {dst_output}' for ws in workspaces])]

call(swaymsg)
