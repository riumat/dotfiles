#!/bin/sh
# DisplayPort-2 is used by the other pc through the kvm, so turn it off here
xrandr --output DisplayPort-2 --off \
       --output HDMI-A-0 --primary --mode 1920x1080 --pos 0x0
