#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
        echo "Please run as root." >&2
        exit 1
fi

# Prerequisites
DIR=$(dirname $0 | xargs realpath)

LOGNAME=$(logname)

cd /home/$LOGNAME


# installed by name so they are never removed as orphan dependencies
pacman -S --needed --noconfirm \
        xorg-server \
        xorg-apps \
        xf86-input-libinput \
        ly

systemctl enable ly@tty1

# i3 and tools used by its config
pacman -S --needed --noconfirm \
        i3-wm \
        i3lock \
        xss-lock \
        dex \
        autotiling \
        dunst \
        libnotify \
        rofi \
        arandr \
        picom \
        polybar \
        maim \
        xclip \
        playerctl \
        thunar \
        feh \
        tmux

usermod -aG video $LOGNAME

sudo -u $LOGNAME mkdir -p \
        /home/$LOGNAME/Pictures/screenshots \
        /home/$LOGNAME/Pictures/wallpapers \
        /home/$LOGNAME/.config/autostart

# hide autostart entries: i3 starts picom, nm-applet is useless without a polybar tray
for app in picom nm-applet; do
        printf '[Desktop Entry]\nHidden=true\n' | sudo -u $LOGNAME tee /home/$LOGNAME/.config/autostart/$app.desktop 1>/dev/null
done

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
