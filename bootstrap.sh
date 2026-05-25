#!/bin/bash
set -e

DOTFILES_REPO="https://github.com/toptuk49/dotfiles.git"

echo "Bootstraping dotfiles..."

# Homebrew installation
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Activate Homebrew now and also add to .bashrc for future sessions
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo >> "$HOME/.bashrc"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >> "$HOME/.bashrc"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

# Installation of necessary packages
echo "Installing necessary packages using Homebrew..."
brew install zsh chezmoi bitwarden-cli age mise

# Register zsh and switch to it
if ! grep -q "$(which zsh)" /etc/shells 2>/dev/null; then
  echo "Adding zsh to /etc/shells..."
  command -v zsh | sudo tee -a /etc/shells
fi
echo "Switch default shell to zsh..."
chsh -s "$(which zsh)"

# Log in Bitwarden
if bw login --check &>/dev/null; then
  echo "Bitwarden already logged in."
else
  echo "Logging in to Bitwarden..."
  if ! bw login; then
    echo "ERROR: Bitwarden login failed."
    echo "Please run 'bw login' and then re-run this script."
    exit 1
  fi
fi

# Unlock Bitwarden vault
echo "Unlocking Bitwarden vault..."
if ! BW_SESSION=$(bw unlock --raw); then
  echo "ERROR: Failed to unlock vault."
  exit 1
fi
export BW_SESSION
echo "Vault unlocked."

# Init and apply dotfiles
echo "Bootstrapping chezmoi dotfiles..."
chezmoi init --apply "$DOTFILES_REPO"

# Launch zsh
echo "Launching zsh..."
exec zsh -l
