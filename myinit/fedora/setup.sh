#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
	echo "Please run as root." >&2
	exit 1
fi

DIR=$(dirname $0 | xargs realpath)
LOGNAME=$(logname)

cd /home/$LOGNAME

# Update and install tools
dnf install -y \
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf update -y

dnf group install --with-optional -y \
	"C Development Tools and Libraries" \
	"Development Tools" \
	"virtualization"

systemctl enable libvirtd
systemctl start libvirtd

usermod -aG libvirt $LOGNAME

dnf install -y \
	neovim \
	alacritty \
	ripgrep \
	flatpak \
	zstd \
	jq \
	fzf \
	tldr \
	tk-devel \
	sqlite-devel \
	libffi-devel \
	bzip2-devel \
	ncurses-devel \
	readline-devel \
	parallel

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y \
	com.bitwarden.desktop \
	com.google.Chrome \
	com.spotify.Client

# Docker
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

usermod -aG docker $LOGNAME

# Asdf
sudo -u $LOGNAME -- bash <<'EOF'
cd 
if ! [ -f .asdf/bin/asdf ]; then
	git clone https://github.com/asdf-vm/asdf.git .asdf
fi

source .asdf/asdf.sh

for P in $(cat .tool-versions | awk '{print $1}'); do
	asdf plugin-add $P
done

asdf install

for P in $(cat .tool-versions | awk '{print $1}'); do
	asdf reshim $P
done
EOF

# Grub
if ! grep -q GRUB_SAVEDEFAULT /etc/default/grub; then
	echo GRUB_SAVEDEFAULT=true >>/etc/default/grub
	grub2-mkconfig -o /boot/grub2/grub.cfg
fi

# Font
if ! fc-list | grep -q 'CaskaydiaCove NF'; then
	mkdir caskaydia-font
	cd caskaydia-font
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip
	unzip *.zip
	mv *.ttf /usr/share/fonts/
	fc-cache -f -v
	cd ..
	rm -rf caskaydia-font
fi
