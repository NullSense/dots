#!/bin/sh
# script to restart the LG monitor for audio to work again
# uses /etc/udev/rules.d/69-monitor-restart.rules

export XAUTHORITY=/home/ongo/.Xauthority
export DISPLAY=:0

xrandr --output DisplayPort-0 --off
xrandr --output DisplayPort-0 --primary --mode 2560x1080 --rate 75 --pos 1920x0 --rotate normal --output DVI-1 --mode 1920x1080 --rate 144 --pos 0x0 --rotate normal --output DVI-0 --off --output HDMI-0 --off
