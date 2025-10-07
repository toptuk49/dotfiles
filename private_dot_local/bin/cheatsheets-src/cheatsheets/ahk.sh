#!/bin/bash

show_ahk() {
  cat <<EOF
⌨️AUTOHOTKEY CHEATSHEET

💡 Overview:
Standardize hotkeys across different platforms using macOS defaults as
the reference standard. This implementation brings macOS-style keyboard
shortcuts to Windows.

⚙️ Installation

Run \`install-windows\` from your WSL environment to:
- Install AutoHotkey via winget
- Deploy hotkey scripts to Windows Startup
- Enable seamless cross-platform keyboard experience

🔑 Hotkeys

Alt + \` - Switch between windows of the same application (Cmd + \` equivalent)
Alt + H - Minimize the active window (Cmd + H equivalent)
Alt + Q - Close the application (Cmd + Q equivalent)
Alt + W - Close the window (Cmd + W equivalent)

🚀 Features

1. Auto starts with Windows
2. Works globally across all applications
3. Maintains consistent muscle memory between macOS and Windows
4. Modular script structure for easy customization

EOF
}
