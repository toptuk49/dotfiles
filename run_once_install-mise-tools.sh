#!/bin/bash
set -e

if command -v mise &>/dev/null; then
	echo "Installing global tools via mise..."
	mise use -g uv
	mise use -g pnpm
	echo "mise tools installed."
else
	echo "mise not found. Skipping."
fi
