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

# Update and install tools
pacman -S --noconfirm \
	rofi \
	arandr \
	xorg-apps \
	picom \
	polybar \
	maim \
	xclip \
	# light \
	playerctl \
	thunar \
	feh

# sudo -u $LOGNAME -- bash <<'EOF'
# cd 
# source .asdf/asdf.sh
pipx install autotiling
# EOF
# 

mkdir -p /etc/X11/xorg.conf.d && tee /etc/X11/xorg.conf.d/15-touchpad.conf <<'EOF' 1>/dev/null
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
        Option "NaturalScrolling" "True"
EndSection
EOF

mkdir -p /etc/X11/xorg.conf.d && tee /etc/X11/xorg.conf.d/10-mouse.conf <<'EOF' 1>/dev/null
Section "InputClass"
  Identifier "mouse"
  MatchIsPointer "yes"
  MatchDriver "libinput"
  Option "AccelProfile" "flat"
  Option "AccelSpeed" "0"
EndSection
EOF
