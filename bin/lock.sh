#!/bin/bash

IMAGE=~/bin/lock.png
SCREENSHOT="maim $IMAGE"

BLURTYPE="2x4"

$SCREENSHOT
convert $IMAGE -blur $BLURTYPE $IMAGE
i3lock -i $IMAGE

rm $IMAGE
