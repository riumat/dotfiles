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

sed -i '1a\    "vscode_custom_css.imports": [\n        "file://'$HOME'/.config/VSCodium/css/custom.css"\n    ],' ~/.config/VSCodium/User/settings.json

PRODUCT="/opt/vscodium/resources/app/product.json"
if ! grep -q '"enableCustomizations": true' "$PRODUCT"; then
    sudo sed -i '1s|{|{"enableCustomizations": true,|' "$PRODUCT"
fi

codium --install-extension vsc/extensions/vscode-custom-css.vsix
