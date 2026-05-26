#!/bin/bash
set -e

if ! command -v brew &>/dev/null; then
	echo "Homebrew not installed. Skipping Brewfile."
	exit 0
fi

echo "Installing Brewfile dependencies..."
if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
	echo "WSL detected. Filtering out container tools..."
	grep -vE "docker|colima" "$HOME/Brewfile" >/tmp/Brewfile.wsl
	brew bundle install --file=/tmp/Brewfile.wsl
	rm /tmp/Brewfile.wsl
else
	brew bundle install --file="$HOME/Brewfile"
fi
