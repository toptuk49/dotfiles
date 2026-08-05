#!/bin/bash
set -euo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/toptuk49/dotfiles.git}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"

echo "Bootstrapping dotfiles via mise..."

echo "Installing mise..."
curl https://mise.run | sh
export PATH="${HOME}/.local/bin:${PATH}"
eval "$(mise activate bash)"

echo "Installing chezmoi..."
cd "$HOME"
mise use -g "chezmoi@latest"
eval "$(mise activate bash)"

echo "Initializing chezmoi..."
INIT_ARGS=()
if [[ -n "$DOTFILES_BRANCH" ]]; then
	INIT_ARGS+=(--branch "$DOTFILES_BRANCH")
fi
chezmoi init "$DOTFILES_REPO" "${INIT_ARGS[@]}"
cd "$(chezmoi source-path)"
mise trust

echo "Applying mise config..."
chezmoi apply -P ~/.config/mise/miserc.toml

mise bootstrap

echo "Applying dotfiles..."
chezmoi apply

echo "Bootstrap complete."

if command -v zsh &>/dev/null; then
	echo "Starting zsh login shell..."
	cd "$HOME"
	exec zsh -l
fi
