#!/bin/bash
set -e

echo "Setting up AHK..."

if [[ -z "$WSL_DISTRO_NAME" ]]; then
  echo "This script must be run from WSL!"
  exit 1
fi

WIN_USERNAME=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
WIN_HOME="/mnt/c/Users/$WIN_USERNAME"
STARTUP_DIR="$WIN_HOME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

echo "Installing AHK scripts..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AHK_SOURCE="$SCRIPT_DIR/../autohotkey"

mkdir -p "$STARTUP_DIR"
cp "$AHK_SOURCE/main.ahk" "$STARTUP_DIR/macos_hotkeys.ahk"
mkdir -p "$STARTUP_DIR/macos_shortcuts"
cp -r "$AHK_SOURCE/macos_shortcuts/"* "$STARTUP_DIR/macos_shortcuts/"

echo "AHK scripts installed to Windows Startup"
echo "Starting AHK..."

cmd.exe /c "start autohotkey.exe \"%USERPROFILE%\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\macos_hotkeys.ahk\"" || echo "Could not start AHK automatically - it will run on next login or it is not installed in the system"
