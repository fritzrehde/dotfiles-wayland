#!/usr/bin/env python3

import subprocess
import json
import shlex
import sys
from dataclasses import dataclass
from typing import List
import argparse

@dataclass
class Sink:
    # a unique identifier.
    id: str
    # a human-readable name.
    name: str


def get_sinks():
    output = subprocess.run(["pactl", "--format=json", "list", "sinks"], capture_output=True, text=True).stdout
    data = json.loads(output)

    for entry in data:
        id = entry["name"]
        name = entry["description"]
        yield Sink(id, name)


def pick_sinks(sinks: List[Sink]) -> List[Sink] | None:
    sink_by_id = {sink.id: sink for sink in sinks}

    separator = ","
    args = [
        "zenity",
        "--title=Create Multi Audio Output Device",
        "--text=Select devices to combine:",
        "--list", "--checklist",
        "--multiple",
        "--column=Pick",     # checkbox column.
        "--column=Name",     # visible sink name column.
        "--column=ID",       # hidden sink id column.
        "--hide-column=3",   # hide the sink id col from ui.
        "--print-column=3",  # return selected sink id col values.
        f"--separator={separator}",
    ]

    for sink in sinks:
        should_be_picked = "FALSE"
        args += [should_be_picked, sink.name, sink.id]

    output = subprocess.run(args, capture_output=True, text=True).stdout.strip()

    if output == "":
        return None

    picked_sink_ids = output.split(separator)
    return [sink_by_id[sink_id] for sink_id in picked_sink_ids]


def create_multi_sink(sinks: List[Sink]):
    slaves = ' '.join(shlex.quote(sink.id) for sink in sinks)
    args = [
        "pactl", "load-module", "module-combine-sink",
        "sink_name=multi_out",
        "node.description=Multi-Output Sink",
        f"slaves={slaves}",
        "channels=2",
        "channel_map=front-left,front-right",
    ]
    print(args)
    subprocess.run(args)


def create():
    sinks = list(get_sinks())

    combined_sinks = pick_sinks(sinks)
    if combined_sinks is not None and combined_sinks != []:
        create_multi_sink(combined_sinks)


@dataclass
class MultiSinkModule:
    module_id: str


def remove_multi_sink(module: MultiSinkModule):
    args = ["pactl", "unload-module", module.module_id]
    subprocess.run(args)


def get_multi_sink_modules():
    output = subprocess.run(["pactl", "--format=json", "list", "modules"], capture_output=True, text=True).stdout
    data = json.loads(output)

    for entry in data:
        if entry["name"] == "module-combine-sink":
            m = re.search(r'sink_name=(.*) node.description', entry["argument"])
            sink_name = m.groups(1)
        id = entry["name"]
        name = entry["description"]
        yield Sink(id, name)



def remove():
    pass


def main():
    parser = argparse.ArgumentParser(
        description="Manage multi-output sinks"
    )
    subparsers = parser.add_subparsers(
        title="subcommands",
        description="valid commands",
        dest="command",
        required=True,
    )

    p_create = subparsers.add_parser("create", help="create a new multi-output sink")
    p_create.set_defaults(func=create)

    p_remove = subparsers.add_parser("remove", help="remove an existing multi-output sink")
    p_remove.set_defaults(func=remove)

    args = parser.parse_args()
    args.func()


if __name__ == '__main__':
    main()
