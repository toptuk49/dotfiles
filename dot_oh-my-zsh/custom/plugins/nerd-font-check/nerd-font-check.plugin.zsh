# Nerd Font Check Plugin for Oh-My-Zsh
# Author: Jarad DeLorenzo (delorenj)
# License: MIT
#
# This plugin checks if required Nerd Fonts are installed and offers to install them.
# It's particularly useful for shell configurations that require specific fonts
# like Powerlevel10k, Starship, or other prompts that use special characters.

# Default configuration
: ${NERD_FONT_CHECK_DEFAULT_FONT:="Hack"}

nerd_font_check() {
    local font_name=${1:-$NERD_FONT_CHECK_DEFAULT_FONT}
    local cask_name="font-${font_name,,}-nerd-font"

    # Check if Homebrew is installed
    if ! command -v brew >/dev/null 2>&1; then
        echo "⚠️  Homebrew is required for font installation"
        return 1
    }

    # Check if font tap is added
    if ! brew tap | grep -q "homebrew/cask-fonts"; then
        echo "📦 Adding homebrew/cask-fonts tap..."
        brew tap homebrew/cask-fonts
    }

    # Check if font is installed
    if ! system_profiler SPFontsDataType | grep -q "${font_name} Nerd Font"; then
        echo "🔤 This configuration works best with ${font_name} Nerd Font"
        echo -n "Would you like to install it? (y/N) "
        read -r response
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
            brew install --cask "${cask_name}"
            echo "✨ Font installed! Please restart your terminal for the changes to take effect"
        else
            echo "⚠️  Some icons might not display correctly without ${font_name} Nerd Font"
        fi
    fi
}

# Auto-run on shell startup if NERD_FONT_CHECK_AUTO is set
if [[ -n "$NERD_FONT_CHECK_AUTO" ]]; then
    nerd_font_check
fi
