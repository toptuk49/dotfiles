# Dotfiles ⚙️

These dotfiles contain personalized configurations and scripts curated
specifically for workflows.

This repository was created using [chezmoi](https://github.com/twpayne/chezmoi).

## Installation 💻

### Prerequisites 📝

- curl
- git
- chezmoi

### Initialization 🚀

Chekout this repo:

```bash
chezmoi init https://github.com/toptuk49/dotfiles.git
```

You can see what would be changed:

```bash
chezmoi diff
```

If you're happy with the changes then apply them:

```bash
chezmoi apply
```

The above commands can be combined into a single command to initialize,
checkout, and apply:

```bash
chezmoi init --apply --verbose https://github.com/toptuk49/dotfiles.git
```

## Included Tools 📦

⚡️ zsh with oh-my-zsh framework

🖋️ Neovim with astronvim configuration

🍺 Common brew packages

🖥️ tmux for terminal multiplex
