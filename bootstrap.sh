#!/bin/bash
set -e

DOTFILES_REPO="https://github.com/toptuk49/dotfiles.git"

echo "Bootstrapping dotfiles..."

# 1. Cross-platform Homebrew setup
if [[ "$(uname)" == "Darwin" ]]; then
  BREW_PATHS=("/opt/homebrew/bin/brew" "/usr/local/bin/brew")
  SHELL_RC="$HOME/.bash_profile"
else # Linux / WSL
  BREW_PATHS=("/home/linuxbrew/.linuxbrew/bin/brew")
  SHELL_RC="$HOME/.bashrc"
fi

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Activate brew in current session and persist it in shell config
for brew_cmd in "${BREW_PATHS[@]}"; do
  if [[ -x "$brew_cmd" ]]; then
    eval "$($brew_cmd shellenv bash)"
    # Add to the appropriate shell startup file
    echo >>"$SHELL_RC"
    echo "eval \"\$($brew_cmd shellenv bash)\"" >>"$SHELL_RC"
    break
  fi
done

# Fail if brew still isn't available
if ! command -v brew &>/dev/null; then
  echo "ERROR: Homebrew not found after installation."
  exit 1
fi

# 2. Install required packages.
echo "Installing necessary packages..."
brew install zsh chezmoi bitwarden-cli age mise

# 3. Register zsh and change default shell
if ! grep -q "$(which zsh)" /etc/shells 2>/dev/null; then
  echo "Adding zsh to /etc/shells..."
  command -v zsh | sudo tee -a /etc/shells
fi
echo "Switching default shell to zsh..."
chsh -s "$(which zsh)"

# 4. Bitwarden login
if bw login --check &>/dev/null; then
  echo "Bitwarden already logged in."
else
  echo "Logging in to Bitwarden..."
  if ! bw login; then
    echo "ERROR: Bitwarden login failed."
    exit 1
  fi
fi

echo "Unlocking Bitwarden vault..."
if ! BW_SESSION=$(bw unlock --raw); then
  echo "ERROR: Failed to unlock vault."
  exit 1
fi
export BW_SESSION

# 5. Apply dotfiles
echo ""
echo "Bootstrapping chezmoi dotfiles... Script will ask for the age passphrase."
chezmoi init --apply "$DOTFILES_REPO"

# 6. Launch zsh
echo "Launching zsh..."
exec zsh -l
