#!/usr/bin/env python
# -*- coding: utf-8 -*-
import subprocess
import argparse
import i3ipc
import shlex
import sys

class Float:

    positions = ['top', 'bottom', 'right', 'left']

    def __init__(self, position='top right', ratio=30):
        self.command = None
        self.i3 = i3ipc.Connection()
        self.tree = self.i3.get_tree()
        self.resolution = [workspace for workspace in self.i3.get_workspaces()
                           if workspace.focused is True][0].rect
        self.position = self._positions(position)
        self.border = self.tree.find_focused().current_border_width
        self.ratio = ratio
        self.controller()

    def _positions(self, position):
        if type(position) is str and position in self.positions:
            position = [position]
        if type(position) is not list:
            sys.exit(f'position should be a list, instead: {type(position)}')
        if len(position) > 2:
            sys.exit(f'Expects max 2: {len(position)}: {position}')
        for word in position:
            if word not in self.positions:
                sys.exit(f'Direction: {word} not in {self.positions}')
        return position

    def win_size(self):
        width, height = None, None
        position = self.position
        ratio = self.ratio

        if len(position) == 1 and 'top' in position or 'bottom' in position:
            width = round(self.resolution['width'] / 100) - self.border
        elif len(position) == 1 and 'right' in position or 'left' in position:
            height = round(self.resolution['height'] / 100) - self.border
        elif len(position) == 2:
            width = round(self.resolution['width'] * ratio / 100) - self.border
            height = round(self.resolution['height'] * ratio / 100) - self.border
        else:
            sys.exit(f'Wrong position {position}')
        return width, height

    def controller(self):
        border = self.border
        ratio = self.ratio
        position = self.position
        x, y = None, None
        width, height = None, None
        resolution = self.resolution

        width = round(resolution['width'] * ratio / 100)
        height = round(resolution['height'] * ratio / 100)

        if len(position) == 1:
            if 'top' in position:
                width = resolution['width'] - 2 * border
                x = resolution['x']
                y = resolution['y']
            elif 'bottom' in position:
                width = resolution['width'] - 2 * border
                x = resolution['x'] + border
                y = resolution['y'] + resolution['height'] - height
            elif 'left' in position:
                height = resolution['height']
                x = resolution['x']
                y = resolution['y']
            elif 'right' in position:
                height = resolution['height']
                x = resolution['x'] + resolution['width'] - width
                y = resolution['y']
        else:
            if 'top' in position and 'left' in position:
                x = resolution['x']
                y = resolution['y']
            elif 'top' in position and 'right' in position:
                x = resolution['width'] - width - 2 * border + resolution['x']
                y = resolution['y']
            elif 'bottom' in position and 'left' in position:
                x = resolution['x']
                y = resolution['height'] - height - 2 * border + resolution['y']
            elif 'bottom' in position and 'right' in position:
                x = resolution['width'] - width - 2 * border + resolution['x']
                y = resolution['height'] - height - 2 * border + resolution['y']

        command = f'i3-msg floating enable, sticky enable, '\
                  f'resize set {width} px {height} px, '\
                  f'move absolute position {x} {y}'
        self.command = command


def main():
    description = ('Accepts a ratio argument in order to get the active output'
                   ' resolution and calculate the percentage ratio.')
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument('-r', '--ratio', dest='ratio', type=int,
                        help='Required: Percentage ratio from the active '
                        'resolution. Ex: --ratio 30')
    parser.add_argument('-p', '--position', dest='position', nargs='+',
                        required=True,
                        type=str, help='Required: Which position to be used: '
                        '[top, bottom, left, right] to open or move window to. '
                        'Ex: --position top; -p top left')

    args = parser.parse_args()
    ratio = args.ratio
    position = args.position

    # execute command
    command = Float(ratio=ratio, position=position).command
    output = subprocess.run(shlex.split(command), capture_output=True)
    return output.stdout.decode('utf-8')


if __name__ == "__main__":
    main()
