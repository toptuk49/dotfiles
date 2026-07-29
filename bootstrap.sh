#!/bin/bash
set -euo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/toptuk49/dotfiles.git}"

echo "Bootstrapping dotfiles via mise..."

echo "Installing mise..."
curl https://mise.run | sh
export PATH="${HOME}/.local/bin:${PATH}"
eval "$(mise activate bash)"

echo "Installing chezmoi, bitwarden, and age..."
mise use -g "chezmoi@latest" "bitwarden@latest" "age@latest"
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

echo "Applying dotfiles (age passphrase may be required)..."
chezmoi apply

echo "Bootstrap complete."

if command -v zsh &>/dev/null; then
	echo "Starting zsh login shell..."
	cd "$HOME"
	exec zsh -l
fi
