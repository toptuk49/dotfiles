#!/bin/bash
set -euo pipefail

CHEZMOI_PROFILE="${CHEZMOI_PROFILE:-dev}"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/toptuk49/dotfiles.git}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"

NO_LOGIN_SHELL=0
for arg in "$@"; do
	if [[ "$arg" == "--no-login-shell" ]]; then
		NO_LOGIN_SHELL=1
	fi
done

export CHEZMOI_PROFILE
export MISE_ENV="${MISE_ENV:-$CHEZMOI_PROFILE}"

echo "Bootstrapping dotfiles via mise (profile: $CHEZMOI_PROFILE)..."

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

mise bootstrap --yes

echo "Applying dotfiles..."
chezmoi apply

echo "Bootstrap complete."

if [[ "$NO_LOGIN_SHELL" -eq 0 ]] && command -v zsh &>/dev/null; then
	echo "Starting zsh login shell..."
	cd "$HOME"
	exec zsh -l
fi
