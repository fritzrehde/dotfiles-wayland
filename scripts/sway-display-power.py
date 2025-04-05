#!/usr/bin/env python3

import argparse
from dataclasses import dataclass
from enum import Enum
import pprint
import subprocess
import json
from typing import List, Optional, Dict, Any


def pick_one(str_to_obj: Dict[str, Any]) -> Optional[Any]:
    result = subprocess.run(
        ["rofi.sh", "default"],
        input="\n".join(str_to_obj.keys()) + "\n",
        text=True,
        capture_output=True,
    )
    if result.returncode == 0:
        selected_str = result.stdout.rstrip("\n")
        return str_to_obj[selected_str]
    else:
        return None


@dataclass
class Display:
    name: str
    model: str
    power: bool

    def status(self) -> str:
        return f"{self.name}: {"on" if self.power else "off"}"

    def __str__(self) -> str:
        return f"{self.name} ({self.model})"

def get_all_displays():
    result = subprocess.run(
        ["swaymsg", "--type", "get_outputs"], capture_output=True, text=True
    )
    displays_json = json.loads(result.stdout)

    for display_json in displays_json:
        name, model, power = (display_json[field] for field in ("name", "model", "power"))
        display = Display(name, model, power)
        yield display

class PowerCommand(Enum):
    On = "on"
    Off = "off"
    Toggle = "toggle"

    def __str__(self):
        return self.value

    def exec(self, display: Display):
        subprocess.run(["swaymsg", "output", display.name, "power", str(self)])


all_displays = list(get_all_displays())


parser = argparse.ArgumentParser(description="Display power commands for Sway")
parser.add_argument(
    "cmd",
    choices=list(map(str, PowerCommand)) + ["status"],
)
parser.add_argument("display_name", choices=[display.name for display in all_displays] + ["all"], nargs="?")
args = parser.parse_args()

match args.cmd:
    case "status":
        print(", ".join(map(Display.status, all_displays)))
    case power_cmd:
        power_cmd = PowerCommand(power_cmd)

        match args.display_name:
            case None:
                # The user hasn't provided any displays, so let them pick using an interactive menu.
                if (display_name := pick_one({str(display):display for display in all_displays})) is not None:
                    picked_displays = [display_name]
                else:
                    # Exit if no display was picked.
                    exit()
            case "all":
                picked_displays = all_displays
            case display_name:
                picked_displays = [display_name]

        for display_name in picked_displays:
            power_cmd.exec(display_name)
