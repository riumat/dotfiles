#!/bin/sh
# small monitor only
xrandr --output DisplayPort-2 --off \
       --output HDMI-A-0 --primary --mode 1920x1080 --rate 120 --pos 0x0
