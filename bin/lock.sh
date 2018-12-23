#!/bin/bash

IMAGE=~/bin/lock.png
SCREENSHOT="maim $IMAGE"
ICON=~/bin/icon.png

BLURTYPE="2x4"

$SCREENSHOT
#convert $IMAGE -blur $BLURTYPE $IMAGE
convert $IMAGE -scale 10% -scale 1000% $IMAGE
#add overlay icon
convert $IMAGE $ICON -gravity center -composite $IMAGE
i3lock -i $IMAGE

rm $IMAGE
