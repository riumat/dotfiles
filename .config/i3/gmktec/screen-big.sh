#!/bin/sh
# big monitor only
xrandr --output HDMI-A-0 --off \
       --output DisplayPort-2 --primary --mode 2560x1440 --rate 59.95 --pos 0x0
