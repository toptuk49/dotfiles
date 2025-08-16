# Nerd Font Check Plugin for Oh-My-Zsh

A simple Oh-My-Zsh plugin that checks if Nerd Fonts are installed and offers to install them automatically. Perfect for shell configurations that require Nerd Fonts (like Powerlevel10k, Starship, etc.).

## Features

- 🔍 Automatically detects if required Nerd Fonts are installed
- 📦 Offers to install fonts using Homebrew
- ⚙️ Configurable default font
- 🚀 Can be run automatically or manually
- 💡 Provides clear feedback and instructions

## Requirements

- [Oh-My-Zsh](https://ohmyz.sh/)
- [Homebrew](https://brew.sh/) (for font installation)

## Installation

1. Clone this repository into your Oh-My-Zsh custom plugins directory:
```bash
git clone https://github.com/delorenj/nerd-font-check ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/nerd-font-check
```

2. Add the plugin to your Oh-My-Zsh plugins in your `.zshrc`:
```bash
plugins=(... nerd-font-check)
```

## Usage

### Automatic Check

To automatically check for fonts when your shell starts:

```bash
# Add to your .zshrc
export NERD_FONT_CHECK_AUTO=1
```

### Manual Check

You can manually check for fonts:

```bash
# Check for default font (Hack)
nerd_font_check

# Check for a specific font
nerd_font_check "JetBrains Mono"
```

### Configuration

You can configure the default font by setting:

```bash
# Add to your .zshrc
export NERD_FONT_CHECK_DEFAULT_FONT="JetBrains Mono"
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) for details.
