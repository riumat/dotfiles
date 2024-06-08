#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
	echo "Please run as root." >&2
	exit 1
fi

DIR=$(dirname $0 | xargs realpath)
LOGNAME=$(logname)
cd /home/$LOGNAME

# Update and install tools
pacman -S --noconfirm nvidia nvidia-utils nvidia-xconfig

nvidia-xconfig
