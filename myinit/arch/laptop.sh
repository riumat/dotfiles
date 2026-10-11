#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
        echo "Please run as root." >&2
        exit 1
fi

# Prerequisites
DIR=$(dirname $0 | xargs realpath)
# $DIR/setup.sh

LOGNAME=$(logname)

cd /home/$LOGNAME

# used by the i3 brightness keys
pacman -S --needed --noconfirm brightnessctl

# keyboard: it + us, switch layout with both ctrl keys
localectl set-x11-keymap --no-convert it,us pc105 "" grp:ctrls_toggle,terminate:ctrl_alt_bksp

tee .xprofile <<'EOF' 1>/dev/null
#!/bin/bash

# per-machine X configuration
HOST_XPROFILE="$HOME/.config/i3/$(cat /etc/hostname)/xprofile"
[ -f "$HOST_XPROFILE" ] && . "$HOST_XPROFILE"

xrandr --dpi 120

xset m 0                                           # mouse accel
xset b 0                                           # bell
xset s 0                                           # sleep timer
xset -dpms                                         # disable display power saving

# Env variables
export GTK_THEME=Adwaita:dark
export QT_STYLE_OVERRIDE=adwaita-dark
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
EOF

tee .Xresources <<'EOF' 1>/dev/null
Xft.dpi: 120
Xft.autohint: 0
Xft.lcdfilter:  lcddefault
Xft.hintstyle:  hintfull
Xft.hinting: 1
Xft.antialias: 1
Xft.rgba: rgb
EOF

chown $LOGNAME:$LOGNAME .xprofile .Xresources
