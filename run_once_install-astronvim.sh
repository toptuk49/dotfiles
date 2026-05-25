#!/bin/bash
set -e

NVIM_CONFIG="$HOME/.config/nvim"

if [ ! -d "$NVIM_CONFIG" ]; then
  echo "Installing AstroNvim base configuration..."
  git clone --depth 1 https://github.com/AstroNvim/template "$NVIM_CONFIG"
  echo "Base AstroNvim installed."
else
  echo "AstroNvim config directory already exists, skipping clone."
fi
