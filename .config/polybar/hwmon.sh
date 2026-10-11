#!/bin/sh
# Floating hardware monitor (polybar cpu click): btop + amdgpu_top + temps.
# A second click closes it.

if tmux -L hwmon has-session 2>/dev/null; then
  tmux -L hwmon kill-server
  exit 0
fi

alacritty --class hwmon --title hwmon -e \
  tmux -L hwmon -f /dev/null new-session -s hwmon btop \; \
    set -g status off \; \
    set -g destroy-unattached on \; \
    split-window -v -l 30% "amdgpu_top --smi" \; \
    split-window -h -l 40% "watch -t -x -n 2 sensors -A 'nvme-*' 'spd5118-*'" \; \
    select-pane -t 0