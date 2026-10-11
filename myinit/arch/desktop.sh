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

# per-machine X configuration
HOST_XPROFILE="$HOME/.config/i3/$(cat /etc/hostname)/xprofile"
[ -f "$HOST_XPROFILE" ] && . "$HOST_XPROFILE"


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

chown $LOGNAME:$LOGNAME .xprofile .Xresources

# dev servers, home lan only
ufw allow from 192.168.1.0/24 to any port 3000:3010 proto tcp comment 'dev server LAN'
ufw allow from 192.168.1.0/24 to any port 5173:5180 proto tcp comment 'Vite LAN'
