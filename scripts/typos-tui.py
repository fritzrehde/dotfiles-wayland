#!/usr/bin/env python

# This interactive TUI (powered by [watchbind](https://github.com/fritzrehde/watchbind)) lets you correct spelling mistakes in your source code. It uses [typos](https://github.com/crate-ci/typos) to identify the spelling mistakes. Unfortunately, typos only lets you correct all mistakes at once, so this TUI gives you fine-grained control over the individual spelling mistakes you want to correct.

import subprocess
import os
import sys


def get_watchbind_lines():
    if (typos_lines := os.environ.get("lines")) is not None:
        return typos_lines.split('\n')
    else:
        return []


def correct_single_spelling_mistake(typos_line):
    """Corrects an individual spelling mistake given a typos line in the format: ./overskride/src/widgets/battery_indicator.rs:47:61: `dependign` -> `depending`"""

    # Extract file path, line number, wrong word, and correct word
    parts = typos_line.split(":")

    file_path = parts[0]
    line_num = parts[1]
    wrong_word = parts[3].split('`')[1]
    correct_word = parts[3].split('`')[3]

    # Use sed to replace the word in-place in the specified file and line
    subprocess.run(["sed", f"{line_num}s/\\b{wrong_word}\\b/{correct_word}/", "-i", file_path])

    print(f"Correct spelling mistake: {typos_line}")


def correct_spelling_mistakes():
    """Corrects all spelling mistakes provided by watchbind's selected lines"""

    for typos_line in get_watchbind_lines():
        correct_single_spelling_mistake(typos_line)


def list_all_spelling_mistakes():
    """Prints a list of all spelling mistakes by calling `typos`"""

    print(subprocess.run(["typos", "--format", "brief"], capture_output=True, text=True).stdout)


def main():
    match len(sys.argv):
        # No args
        case 1:
            home = os.environ.get("XDG_CONFIG_HOME")
            subprocess.run(["watchbind", "--config-file", f"{home}/watchbind/typos.toml"])
        case 2:
            sub_command = sys.argv[1]
            match sub_command:
                case "list":
                    list_all_spelling_mistakes()
                case "correct":
                    correct_spelling_mistakes()
                case _:
                    print(f"Error: unknown command: {sub_command}", file=sys.stderr)
                    exit(1)


if __name__ == "__main__":
    main()
