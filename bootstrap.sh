#!/bin/bash
set -euo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/toptuk49/dotfiles.git}"

echo "Bootstrapping dotfiles via mise..."

echo "Installing mise..."
curl https://mise.run | sh
export PATH="${HOME}/.local/bin:${PATH}"
eval "$(mise activate bash)"

echo "Installing chezmoi and bitwarden..."
mise use -g "chezmoi@latest" "bitwarden@latest"
eval "$(mise activate bash)"

if command -v bw &>/dev/null; then
	if ! bw login --check &>/dev/null 2>&1; then
		echo "Logging in to Bitwarden..."
		bw login
	fi
	echo "Unlocking Bitwarden vault..."
	BW_SESSION=$(bw unlock --raw)
	export BW_SESSION
fi

echo "Initializing chezmoi (requires Bitwarden for .chezmoi.toml.tmpl)..."
chezmoi init "$DOTFILES_REPO"
cd "$(chezmoi source-path)"
mise trust

echo "Applying mise config (auto_env must be set before bootstrap)..."
chezmoi apply -P ~/.config/mise/miserc.toml

mise bootstrap

echo "Applying dotfiles..."
chezmoi apply

echo "Bootstrap complete."

echo ""
echo "Optional: configure SSH keys and git identity for this machine:"
echo "  gh auth login                                       # creates ~/.ssh/id_ed25519 + registers it (auth)"
echo "  ssh-keygen -t ed25519 -f ~/.ssh/key_sign            # signing key"
echo "  gh ssh-key add ~/.ssh/key_sign.pub --type signing   # register signing key"
echo "  git config --global user.name  \"<name>\""
echo "  git config --global user.email \"<email>\""
echo "  git config --global user.signingkey ~/.ssh/key_sign"

if command -v zsh &>/dev/null; then
	echo "Starting zsh login shell..."
	cd "$HOME"
	exec zsh -l
fi
