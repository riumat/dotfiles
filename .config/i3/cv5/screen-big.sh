#!/bin/sh
# big monitor only
xrandr --output DP-2 --off \
       --output DP-4 --primary --mode 2560x1440 --rate 120 --pos 0x0
