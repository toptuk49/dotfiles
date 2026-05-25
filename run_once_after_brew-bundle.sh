#!/bin/bash
set -e

if ! command -v brew &>/dev/null; then
	echo "Homebrew not installed. Skipping Brewfile."
	exit 0
fi

echo "Installing Brewfile dependencies..."
brew bundle install --file="$HOME/Brewfile"
