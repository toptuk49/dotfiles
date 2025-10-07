#!/bin/bash
set -e

echo "Installing packages via winget..."

if [[ -z "$WSL_DISTRO_NAME" ]]; then
  echo "This script must be run from WSL!"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="$SCRIPT_DIR/../winget/winget-packages.json"

if [[ -f "$PACKAGES_FILE" ]]; then
  WIN_PACKAGES_PATH=$(wslpath -w "$PACKAGES_FILE")
  cmd.exe /c "winget import -i \"$WIN_PACKAGES_PATH\" --accept-package-agreements --accept-source-agreements --disable-interactivity" || echo "Some packages may have issues"
else
  echo "Packages file not found at $PACKAGES_FILE"
  exit 1
fi

echo "Packages installed"
