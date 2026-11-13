#!/bin/sh
# small monitor only
xrandr --output DP-4 --off \
       --output DP-2 --primary --mode 1920x1080 --rate 120 --pos 0x0
