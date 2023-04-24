#!/usr/bin/python

# determine the next empty workspace in sway

import json
from subprocess import check_output

workspaces = json.loads(check_output(["swaymsg", "-t", "get_workspaces"]))
occupied_workspaces = [ws["num"] for ws in workspaces if ws["representation"]]

for next_num in range(1, 11):
    if next_num not in occupied_workspaces:
        print(next_num, end="")
        exit(0)

eprint("No empty workspaces found")
exit(1)
