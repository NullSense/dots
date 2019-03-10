#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Author: Elodin
Place: irc@freenote#i3
"""
import subprocess
import argparse
import i3ipc
import shlex
import time


def class_exists(connection, window_class):
    tree = connection.get_tree()
    try:
        return tree.find_instanced(window_class)[0]
    except IndexError:
        return False


def title_exists(connection, title):
    tree = connection.get_tree()
    try:
        return tree.find_named(title)[0]
    except IndexError:
        return False


def run(command):
    output = subprocess.run(shlex.split(command), capture_output=True)
    return output.stdout.decode('utf-8')


def parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('-t', '--title', dest='title', type=str)
    parser.add_argument('-c', '--class', dest='window_class', type=str)
    parser.add_argument('-a', '--app', dest='app', required=True, type=str)
    args = parser.parse_args()
    return args


def main():
    connection = i3ipc.Connection()
    tree = connection.get_tree()
    args = parser()
    app, title, window_class = args.app, args.title, args.window_class

    if title:
        results = tree.find_named(title)
    elif window_class:
        results = tree.find_instanced(window_class)
    else:
        import sys
        sys.exit('Must either provide a -t/--tittle or a -c/--class')
    # if window is not found, open it
    if len(results) == 0:
        cmd_open = f'i3-msg exec "{app}"'
        run(cmd_open)
        if title:
            while not title_exists(connection, title):
                time.sleep(0.01)
            window = title_exists(connection, title)
        elif window_class:
            while not class_exists(connection, window_class):
                time.sleep(0.01)
            window = class_exists(connection, window_class)
        window.command('move scratchpad')
    else:
        if title:
            command = f'i3-msg \\[title="{title}"\\] scratchpad show'
        elif window_class:
            command = f'i3-msg \\[instance="{window_class}"\\] scratchpad show'
        run(command)


if __name__ == "__main__":
    main()
