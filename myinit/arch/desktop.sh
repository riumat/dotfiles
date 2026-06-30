#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
	echo "Please run as root." >&2
	exit 1
fi

DIR=$(dirname $0 | xargs realpath)

LOGNAME=$(logname)

cd /home/$LOGNAME

tee .xprofile <<'EOF' 1>/dev/null
#!/bin/bash

# X configuration
xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 2560x0 --rotate normal --output DP-0 --primary --mode 2560x1440 --pos 0x0 --rotate normal --output DP-1 --off


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
Xft.dpi: 110
Xft.autohint: 0
Xft.lcdfilter:  lcddefault
Xft.hintstyle:  hintfull
Xft.hinting: 1
Xft.antialias: 1
Xft.rgba: rgb
EOF
