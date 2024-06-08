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

tee .xprofile <<'EOF' 1>/dev/null
#!/bin/bash

# X configuration
xrandr --dpi 112

xset m 0                                           # mouse accel
xset b 0                                           # bell
xset s 0                                           # sleep timer
xset -dpms                                         # disable display power saving
setxkbmap 'us,us(intl)' -option 'grp:ctrls_toggle' # keyboard

# Env variables
export GTK_THEME=Adwaita:dark
export QT_STYLE_OVERRIDE=adwaita-dark
EOF

tee .Xresources <<'EOF' 1>/dev/null
Xft.dpi: 112
Xft.autohint: 0
Xft.lcdfilter:  lcddefault
Xft.hintstyle:  hintfull
Xft.hinting: 1
Xft.antialias: 1
Xft.rgba: rgb
EOF
