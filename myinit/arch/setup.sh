#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
	echo "Please run as root." >&2
	exit 1
fi

DIR=$(dirname $0 | xargs realpath)
LOGNAME=$(logname)

cd /home/$LOGNAME

pacman -Syu

# # aur
# pacman -S --needed --noconfirm git base-devel
# git clone https://aur.archlinux.org/yay.git /tmp/yay
# cd tmp/yay
# sudo -u $LOGNAME makepkg -si --noconfirm
# rm -rf /tmp/yay
# yay -Y --gendb
# yay -Y --devel --save
# yay -Syu

# virualization
pacman -S --noconfirm dnsmasq qemu-full libvirt virt-manager

systemctl enable libvirtd
systemctl start libvirtd

usermod -aG libvirt $LOGNAME

# general utils
pacman -R --noconfirm xterm

pacman -S --noconfirm \
	neovim \
	alacritty \
	ripgrep \
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
	python \
	python-pip \
	python-pipx \
	ttf-cascadia-code-nerd \
	ttf-iosevka-nerd \
	otf-geist-mono-nerd

# sudo -u $LOGNAME -- bash <<'EOF'
# cd 
# if ! [ -f .asdf/bin/asdf ]; then
# 	git clone https://github.com/asdf-vm/asdf.git .asdf
# fi
# 
# source .asdf/asdf.sh
# 
# for P in $(cat .tool-versions | awk '{print $1}'); do
# 	asdf plugin-add $P
# done
# 
# asdf install
# 
# for P in $(cat .tool-versions | awk '{print $1}'); do
# 	asdf reshim $P
# done
# EOF

# audio

pacman -S --noconfirm \
	pipewire \
	wireplumber \
	pipewire-pulse \
	pavucontrol

mkdir -p /etc/X11/xinit/xinitrc.d && tee /etc/X11/xinit/xinitrc.d/60-audio.sh <<'EOF' 1>/dev/null
#!/bin/sh

/usr/bin/pipewire &
/usr/bin/pipewire-pulse &
/usr/bin/wireplumber &
EOF
