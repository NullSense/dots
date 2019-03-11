#!/usr/bin/env bash

IMAGE=~/bin/lock.png
SCREENSHOT="maim $IMAGE"
ICON=~/bin/icon.png

BLURTYPE="0x5"

$SCREENSHOT
convert $IMAGE -blur $BLURTYPE $IMAGE
convert $IMAGE -scale 10% -scale 1000% $IMAGE
i3lock -i $IMAGE

rm $IMAGE
