#!/usr/bin/env bash

# signal instead of ipc: bars restarting on screenchange-reload miss ipc messages
pkill -u "$UID" -x polybar
for _ in $(seq 10); do
        pgrep -u "$UID" -x polybar >/dev/null || break
        sleep 0.2
done
pkill -9 -u "$UID" -x polybar 2>/dev/null

# --list-monitors skips outputs turned off with xrandr --off
for M in $(polybar --list-monitors | cut -d":" -f1); do
        echo "---" >> "/tmp/polybar-$M.log"
        MONITOR=$M polybar bar >> "/tmp/polybar-$M.log" 2>&1 & disown
done
