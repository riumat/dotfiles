#!/bin/bash

set -e

if ! command -v codium &> /dev/null; then
    yay -S --noconfirm vscodium-bin
fi

mkdir -p ~/.config/VSCodium/User
mkdir -p ~/.config/VSCodium/css

cp vsc/settings.json ~/.config/VSCodium/User/
cp vsc/keybindings.json ~/.config/VSCodium/User/
cp vsc/custom.css ~/.config/VSCodium/css/

PRODUCT="/opt/vscodium/resources/app/product.json"
if ! grep -q '"enableCustomizations": true' "$PRODUCT"; then
    sudo sed -i '1s|{|{"enableCustomizations": true,|' "$PRODUCT"
fi

codium --install-extension vsc/extensions/vscode-custom-css.vsix

codium --user-data-dir ~/.config/VSCodium