#!/bin/bash
set -e

echo "Installing packages via winget..."

if [[ -z "$WSL_DISTRO_NAME" ]]; then
  echo "This script must be run from WSL!"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$SCRIPT_DIR/../winget/Brewfile"

if [[ -f "$BREWFILE" ]]; then
  cmd.exe /c "winget import -i \"%USERPROFILE%\\dotfiles\\private_dot_local\\bin\\windows\\winget\\winget-packages.json\" --accept-package-agreements --accept-source-agreements --disable-interactivity" || echo "Some packages may have issues"
else
  echo "Brewfile not found at $BREWFILE"
  exit 1
fi

echo "Packages installed"
