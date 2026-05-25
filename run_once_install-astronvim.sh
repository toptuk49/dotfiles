#!/bin/bash
set -euo pipefail

NVIM_CONFIG="$HOME/.config/nvim"

if [ ! -f "$NVIM_CONFIG/init.lua" ]; then
  echo "Installing AstroNvim base configuration..."
  rm -rf "$NVIM_CONFIG"
  git clone --depth 1 https://github.com/AstroNvim/template "$NVIM_CONFIG"
  echo "Base AstroNvim installed."
else
  echo "AstroNvim base config already present, skipping clone."
fi
