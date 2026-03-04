#!/bin/sh -e

ssysRootDir=$(X= cd -- "$(dirname -- "$0")" && pwd -P)

if command -v pixi >/dev/null 2>&1; then
    echo "pixi is installed"
else
    echo "pixi is not installed, start install pixi..."
    wget -qO- https://pixi.sh/install.sh | sh
    if [ -f "$HOME/.zshrc" ]; then
        source "$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
    fi
fi

# install platform dependency packages
cd "$ssysRootDir" || { echo "Unable to enter directory: $ssysRootDir"; exit 1; }
echo "pixi lock..."
pixi lock
echo "pixi install..."
pixi install
echo "pixi install pixi-pack..."
pixi global install pixi-pack
echo "pixi-pack --create-executable..."
pixi-pack --create-executable -o build/environment
