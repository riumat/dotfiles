#!/bin/bash
# run order: setup.sh -> i3.sh -> desktop.sh | laptop.sh -> (nvidia.sh)

if [ "$(id -u)" -ne 0 ]; then
        echo "Please run as root." >&2
        exit 1
fi

DIR=$(dirname $0 | xargs realpath)
LOGNAME=$(logname)

cd /home/$LOGNAME

sed -i 's/^#Color$/Color/; s/^#VerbosePkgLists$/VerbosePkgLists/' /etc/pacman.conf

pacman -Syu --noconfirm

# makepkg: build on all cores, skip -debug packages
mkdir -p /etc/makepkg.conf.d
printf '%s\n' 'MAKEFLAGS="-j$(nproc)"' 'OPTIONS=("${OPTIONS[@]/#debug/!debug}")' > /etc/makepkg.conf.d/custom.conf

# # aur
# pacman -S --needed --noconfirm git base-devel
# git clone https://aur.archlinux.org/yay.git /tmp/yay
# cd tmp/yay
# sudo -u $LOGNAME makepkg -si --noconfirm
# rm -rf /tmp/yay
# yay -Y --gendb
# yay -Y --devel --save
# yay -Syu
#
# aur packages, install as user after yay:
# yay -S visual-studio-code-bin

# keyboard
localectl set-x11-keymap --no-convert it pc105 "" terminate:ctrl_alt_bksp
localectl set-keymap --no-convert it

# virtualization
pacman -S --needed --noconfirm dnsmasq qemu-full libvirt virt-manager

systemctl enable libvirtd
systemctl start libvirtd

usermod -aG libvirt $LOGNAME

# general utils
pacman -R --noconfirm xterm 2>/dev/null

pacman -S --needed --noconfirm \
        git \
        base-devel \
        neovim \
        alacritty \
        ripgrep \
        fd \
        bat \
        zstd \
        jq \
        fzf \
        tldr \
        tk \
        sqlite \
        libffi \
        bzip2 \
        ncurses \
        readline \
        parallel \
        stow \
        inetutils \
        man-db \
        man-pages \
        python \
        python-pip \
        python-pipx \
        ttf-cascadia-code-nerd \
        otf-geist-mono-nerd


# audio
pacman -S --needed --noconfirm \
    pipewire \
    wireplumber \
    pipewire-pulse \
    pipewire-alsa \
    pipewire-jack \
    pavucontrol


# pacman maintenance
pacman -S --needed --noconfirm pacman-contrib reflector

systemctl enable paccache.timer

grep -q -- '^--country' /etc/xdg/reflector/reflector.conf || \
        echo '--country Italy,Germany,France,Switzerland,Austria' >> /etc/xdg/reflector/reflector.conf
systemctl enable reflector.timer


# firewall
pacman -S --needed --noconfirm ufw

ufw default deny incoming
ufw default allow outgoing
ufw allow in on virbr0 comment 'libvirt: DHCP/DNS for VMs'
ufw route allow in on virbr0 comment 'libvirt: VM NAT'
ufw route allow out on virbr0 comment 'libvirt: VM NAT'
ufw --force enable
systemctl enable ufw
