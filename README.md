# Dotfiles ⚙️

These dotfiles contain personalized configurations and scripts curated
specifically for workflows.

They are managed with [chezmoi](https://github.com/twpayne/chezmoi), featuring age encryption for secrets and Bitwarden integration.

## Quick Start 🚀

Neovim requires build-essentials to install plugins. Here are some examples of how to install them on your system:

**Ubuntu**:

```sh
sudo apt-get install build-essentials
```

**macOS**:

```sh
xcode-select --install
```

Then run a single command:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/toptuk49/dotfiles/main/bootstrap.sh)"
```

The script will automatically:

- install Homebrew, zsh, chezmoi, Bitwarden CLI, age and mise;

- register zsh as the default shell;

- prompt you to log in to Bitwarden for secret access;

- initialize and apply all configurations;

During the first `chezmoi apply`, you'll be asked for the passphrase to decrypt the age identity key (stored encrypted in the repository), after which all private SSH and other sensitive files are unpacked automatically.

## Adapting for a New User 🔄

These dotfiles are **personal** and must be customized before you can use them. Below are the essential steps to make them yours.

### 1. Bitwarden items

All secret data (passwords, keys, email, usernames) is pulled from Bitwarden using the names defined in `.chezmoi.toml.tmpl`.

You must create your own Bitwarden items or rename the existing ones to match what you use (the `bitwarden "item" "..."` calls).

### 2. Age identity and encryption

The repository contains encrypted private SSH keys (`*.age`). They are encrypted with a **public** age key, while the corresponding **secret** key is stored encrypted by a passphrase `dot_key.age`.

You **must** generate your own age key pair and use your passphrase to encrypt the secret key:

```sh
# Navigate to dotfiles folder
chezmoi cd

# Generate a new age key
age-keygen -o dot_key

# Encrypt the secret key with a strong passphrase (output to dot_key.age)
age -p dot_key > dot_key.age

# Remove the plaintext secret key
rm dot_key
```

Then add your **public** age key to the Bitwarden item `Chezmoi Age Public Key` (in the notes field).

Now you can encrypt your own SSH keys using that public key and add them to chezmoi:

```sh
chezmoi add --encrypt ~/.ssh/<your_private_key>
```

Repeat for all your SSH keys (auth and signing). Update the `private_key_files` list in `.chezmoi.toml.tmpl` to match the filenames you need.

### 3. SSH keys in `.chezmoi.toml.tmpl`

The file `.chezmoi.toml.tmpl` defines accounts and their associated private key files. Edit the `accounts` list to reflect your own identities:

- Change `remote_pattern`, `email`, `username` placeholders to your own (or make them point to correct Bitwarden items).

- Adjust `private_key_files` to the names of the encrypted key files you added.

After these changes, `chezmoi apply` will decrypt and place your private keys correctly, and the `autodetect_account.zsh.tmpl` script will switch Git profiles automatically based on repository URLs.

### 4. Passphrase

The passphrase used to encrypt `dot_key.age` is yours alone. **Never** store it in the repository. Every user must generate their own age key and set their own passphrase.

## What's inside 📦

- **Zsh** + Oh My Zsh - the main shell with plugins (git, z, fzf, syntax-highlighting, autosuggestions, poetry).

- **Neovim** - configuration based on [AstroNvim v6](https://github.com/AstroNvim/AstroNvim). Only user overrides (plugins, mappings, community packs) are kept in the repository; the base template is installed by `run_once_install-astronvim` are kept in the repository; the base template is installed by `run_once_install-astronvim.sh`.

- **tmux** - terminal multiplexer with vi-style navigation, custom prefix C-a, and convenient pane splitting.

- **Git** - automatic account detection by remote URL and SSH commit signing

- **SSH Config** – generated from `.chezmoi.toml.tmpl` (`private_dot_ssh/config.tmpl`) and pins the correct authentication key per account. Clone repositories using the corresponding host alias:
  - `git clone git@github.com-primary:user/repo.git`
  - `git clone git@github.com-misc:user/repo.git`
  - `git clone git@sourcecraft.dev-sourcecraft:user/repo.git`

- **Brewfile** - list of crossplatform (Linux, macOS) packages (ripgrep, fzf, neovim, tmux, lazygit, etc.). Applied by `run_once_before_brew-bundle.sh`.

- **mise** - version manager for language toolchains; globally installs poetry.

- **Bitwarden** - source of all secrets (public keys, email, username), injected into chezmoi templates.

- **age** - robust encryption for private SSH keys and the age identity. No secret key is ever stored in plaintext within the repository.

## Security 🔐

- The age secret key is **never** stored in plaintext in the repository - only in an encrypted form (`dot_key.age`), protected by a passphrase.

- All private SSH keys are encrypted with the public age key and are decrypted at runtime.

- Passwords and sensitive data are never hardcoded; they are pulled from Bitwarden via chezmoi templates.
