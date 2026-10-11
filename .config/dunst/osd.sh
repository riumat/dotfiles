#!/bin/sh
# volume/brightness change + progress bar through dunst;
# the stack tag makes each bar replace the previous one
show() { notify-send -a osd -u low -h string:x-dunst-stack-tag:osd -h "int:value:$1" "$2"; }

case "$1" in
  vol-*|mic-mute)
    case "$1" in
      vol-up)   pactl set-sink-mute @DEFAULT_SINK@ 0; pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
      vol-down) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
      vol-mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
      mic-mute) pactl set-source-mute @DEFAULT_SOURCE@ toggle
                if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q yes
                then show 0 "󰍭  microfono muto"; else show 100 "󰍬  microfono attivo"; fi
                exit ;;
    esac
    vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1 | tr -d %)
    if pactl get-sink-mute @DEFAULT_SINK@ | grep -q yes
    then show "$vol" "󰝟  muto"; else show "$vol" "󰕾  $vol%"; fi ;;
  bri-*)
    command -v brightnessctl >/dev/null || exit 0  # desktop with external monitors
    if [ "$1" = bri-up ]; then brightnessctl -q set +5%; else brightnessctl -q set 5%-; fi
    b=$(brightnessctl -m | cut -d, -f4 | tr -d %)
    show "$b" "󰃟  $b%" ;;
esac
