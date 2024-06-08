#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
	echo "Please run as root." >&2
	exit 1
fi

# Prerequisites
DIR=$(dirname $0 | xargs realpath)
$DIR/setup.sh

LOGNAME=$(logname)

cd /home/$LOGNAME

# Update and install tools
dnf install -y \
	sway \
	rofi-wayland \
	wdisplays \
	waybar \
	grim \
	slurp \
	wl-clipboard \
	light \
	playerctl

sudo -u $LOGNAME -- bash <<'EOF'
cd 
source .asdf/asdf.sh
pip install autotiling
EOF

# Configs
mkdir -p /usr/share/wayland-sessions && tee /usr/share/wayland-sessions/mysway.desktop <<'EOF' 1>/dev/null
[Desktop Entry]
Name=MySway
Comment=An i3-compatible Wayland compositor
Exec=start-sway
Type=Application
EOF

mkdir -p /usr/bin && cp $DIR/sway.d/start-sway /usr/bin/
chmod +x /usr/bin/start-sway
