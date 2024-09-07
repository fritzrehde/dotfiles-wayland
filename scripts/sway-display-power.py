#!/usr/bin/env python3

import argparse
from dataclasses import dataclass
from enum import Enum
import pprint
import subprocess
import json
from typing import List, Optional


def pick_one(stdin_lines: List[str]) -> Optional[str]:
    result = subprocess.run(
        ["rofi.sh", "default"],
        input="\n".join(stdin_lines) + "\n",
        text=True,
        capture_output=True,
    )
    if result.returncode == 0:
        return result.stdout.rstrip("\n")
    else:
        return None


@dataclass
class Display:
    name: str
    power: bool

    def status(self) -> str:
        return f"{self.name}: {"on" if self.power else "off"}"

@dataclass
class Displays:
    displays: List[Display]

    def names(self) -> List[str]:
        return [display.name for display in self.displays]


def get_all_displays() -> Displays:
    result = subprocess.run(
        ["swaymsg", "--type", "get_outputs"], capture_output=True, text=True
    )
    displays_json = json.loads(result.stdout)
    # pprint.pprint(displays_json)
    return Displays([
        Display(display["name"], display["power"]) for display in displays_json
    ])


class PowerCommand(Enum):
    On = "on"
    Off = "off"
    Toggle = "toggle"

    def __str__(self):
        return self.value

    def exec(self, display_name: str):
        subprocess.run(["swaymsg", "output", display_name, "power", str(self)])


all_displays = get_all_displays()


parser = argparse.ArgumentParser(description="Display power commands for Sway")
parser.add_argument(
    "cmd",
    choices=list(map(str, PowerCommand)) + ["status"],
)
parser.add_argument("display_name", choices=all_displays.names() + ["all"], nargs="?")
args = parser.parse_args()

match args.cmd:
    case "status":
        print(", ".join(map(Display.status, all_displays.displays)))
    case power_cmd:
        power_cmd = PowerCommand(power_cmd)

        match args.display_name:
            case None:
                if (display_name := pick_one(all_displays.names())) is not None:
                    display_names = [display_name]
                else:
                    # Exit if no display was picked.
                    exit()
            case "all":
                display_names = all_displays.names()
            case display_name:
                display_names = [display_name]

        for display_name in display_names:
            power_cmd.exec(display_name)
