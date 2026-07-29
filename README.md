# Dotfiles ⚙️

Personal shell, editor, and tooling configurations. The repository is a [chezmoi](https://github.com/twpayne/chezmoi) source state: templates and encrypted secrets are rendered into the home directory on `chezmoi apply`. Machine setup (tools, system packages, external repos) is handled declaratively by [mise bootstrap](https://mise.jdx.dev/dev-tools/bootstrap.html).

## Architecture

Two layers split responsibilities:

| Layer | Role |
|-------|------|
| **chezmoi** | Dotfiles, Go templates, age-encrypted secrets, account-specific config |
| **mise** | Tool versions, apt packages (Linux), git repos (Oh My Zsh, AstroNvim), login shell |

Secrets never live in plaintext in git. Public data (emails, usernames, signing keys) is pulled from Bitwarden at template render time; private SSH keys are stored age-encrypted and decrypted on apply.

## Repository layout

Chezmoi naming maps source paths to targets:

| Source prefix | Target | Notes |
|---------------|--------|-------|
| `dot_*` | `~/.*` | e.g. `dot_zshrc` → `~/.zshrc` |
| `private_dot_config/` | `~/.config/` | private permissions |
| `dot_ssh/` | `~/.ssh/` | config templates + encrypted keys |
| `*.tmpl` | rendered file | Go templates with Bitwarden/age data |
| `run_once_*` | one-shot scripts | run before/after apply |

Bootstrap config lives at the source root and is consumed in place (not deployed to `$HOME`):

- **`bootstrap.sh`** — first-run script: mise → Bitwarden → chezmoi init → partial apply of `miserc.toml` → `mise bootstrap` → `chezmoi apply`
- **`mise.toml`** — `[tools]`, `[bootstrap.repos]`, `[bootstrap.user]`
- **`mise.linux.toml`** — Linux apt packages; loaded when `auto_env` is enabled
- **`private_dot_config/mise/miserc.toml`** → `~/.config/mise/miserc.toml` with `auto_env = true`

Partial apply of `miserc.toml` before `mise bootstrap` is required: `auto_env` must be active so `mise.linux.toml` installs `git`, `zsh`, and `build-essential` before the full `chezmoi apply`.

## Secrets and accounts

**`.chezmoi.toml.tmpl`** is the single source of truth for identities. It defines:

- age encryption (identity in `dot_key`, recipient from Bitwarden item `Chezmoi Age Public Key`)
- Bitwarden auto-unlock
- `[data.accounts]` — per-account email, username, SSH public key, and encrypted private key filenames

**Age identity:** the secret key is stored encrypted as `dot_key.age` (passphrase-protected, not in git as plaintext). `run_once_before_decrypt-private-key.sh.tmpl` decrypts it to `dot_key` in the source dir on first apply.

**SSH keys:** private keys live as `dot_ssh/encrypted_private_key_*.age`. Templates (`dot_ssh/config.tmpl`, `private_dot_config/zsh/ssh/agent.zsh.tmpl`) reference key names from `[data.accounts]`.

**Git signing:** `dot_gitconfig.tmpl` enables SSH commit signing; `dot_ssh/allowedSigners.tmpl` lists allowed signers per account.

## Shell (zsh)

```
~/.zshrc                          ← dot_zshrc
  └── ~/.config/zsh/init.zsh      ← private_dot_config/zsh/init.zsh
        ├── env.d/00-mise.zsh     ← mise activate
        ├── plugins/              ← Oh My Zsh theme and plugin list
        ├── ssh/                  ← agent and key loading (templated)
        └── git/                  ← autodetect_account.zsh.tmpl
```

Oh My Zsh and plugins are cloned by `mise bootstrap` into `~/.oh-my-zsh`. Plugin config is in `private_dot_config/zsh/plugins/`.

`autodetect_account.zsh.tmpl` sets `user.email`, `user.name`, and `user.signingkey` per repo based on remote URL and the accounts defined in `.chezmoi.toml.tmpl`.

## Components

- **Neovim** — [AstroNvim](https://github.com/AstroNvim/template) template cloned to `~/.config/nvim` by mise; overrides in `private_dot_config/nvim/lua/`
- **tmux** — modular config in `private_dot_config/tmux/conf.d/`; `10-options.conf.tmpl` sets `default-shell zsh`
- **lazygit** — `private_dot_config/lazygit/config.yml`
- **Tools** — managed in `mise.toml` (gh, neovim, tmux, uv, pnpm, ripgrep, fzf, jq, lazygit, …)

## SSH host aliases

`dot_ssh/config.tmpl` generates per-account host aliases:

```
git clone git@github.com-primary:user/repo.git
git clone git@github.com-misc:user/repo.git
git clone git@sourcecraft.dev-sourcecraft:user/repo.git
```

## Workflow

Edit the source, not deployed files:

```sh
chezmoi cd # open shell in source dir (~/.local/share/chezmoi)
chezmoi edit ~/.zshrc
chezmoi diff
chezmoi apply
chezmoi update # pull source + apply
```

After changing `mise.toml` or bootstrap config:

```sh
chezmoi cd
mise trust
mise bootstrap
```
