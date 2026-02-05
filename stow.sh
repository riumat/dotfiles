#!/bin/bash

cd $(dirname $(realpath @0))

STOW_ARGS=$@

stow $STOW_ARGS -t ~ .

chmod +x ~/.config/polybar/calendar.sh 2>/dev/null
chmod +x ~/.config/polybar/date.sh 2>/dev/null