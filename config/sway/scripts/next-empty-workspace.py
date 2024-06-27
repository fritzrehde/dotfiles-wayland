#!/usr/bin/env python

# Determine the next empty workspace in sway

import json
from subprocess import check_output
import sys

TOTAL_WORKSPACES=10

workspaces = json.loads(check_output(["swaymsg", "-t", "get_workspaces"]))
occupied_workspaces = [ws["num"] for ws in workspaces if ws["representation"] != "H[]"]

for next_num in range(1, TOTAL_WORKSPACES+1):
    if next_num not in occupied_workspaces:
        print(next_num, end="")
        exit(0)

print("No empty workspaces found", file=sys.stderr)
exit(1)
