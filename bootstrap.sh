#!/bin/bash
set -e

DOTFILES_REPO="https://github.com/toptuk49/dotfiles.git"

echo "Bootstraping dotfiles..."

# 1. Homebrew installation
if ! command -v brew &>/dev/null; then
	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https:/raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Activate Homebrew in the current session
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# 2. Installation of necessary packages
echo "Installing necessary packages using Homebrew..."
brew install zsh chezmoi bitwarden-cli age mise

# 3. Register ssh and switch to it
if ! grep -q "$(which zsh)" /etc/shells 2>/dev/null; then
	echo "Adding zsh to /etc/shells..."
	command -v zsh | sudo tee -a /etc/shells
fi
echo "Switch default shell to zsh..."
chsh -s "$(which zsh)"

# 4. Log in Bitwarden
echo ""
echo "Logging in Bitwarden..."
bw login --check
if ! bw login --check &>/dev/null; then
	bw login
fi
echo "Unlocking the vault..."
export BW_SESSION
BW_SESSION=$(bw unlock --raw)
echo "Bitwarden session has been saved."

# 5. Init and apply dotfiles
echo ""
echo "Bootstrapping chezmoi dotfiles..."
chezmoi init --apply "$DOTFILES_REPO"

echo ""
echo "It's ready! Restart your terminal or run 'exec zsh' to continue."
