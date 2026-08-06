# Dotfiles ⚙️

Personal shell, editor, and tooling configurations. The repository is a [chezmoi](https://github.com/twpayne/chezmoi) source state: files are rendered into the home directory on `chezmoi apply`. Machine setup (tools, system packages, external repos) is handled declaratively by [mise bootstrap](https://mise.jdx.dev/dev-tools/bootstrap.html).

No personal data, no secrets, and no secrets manager are involved at render time.

## Architecture

Two layers split responsibilities:

| Layer | Role |
|-------|------|
| **chezmoi** | Dotfiles and static configs |
| **mise** | Tool versions, apt packages (Linux), git repos (Oh My Zsh, AstroNvim), login shell |

## Repository layout

Chezmoi naming maps source paths to targets:

| Source prefix | Target | Notes |
|---------------|--------|-------|
| `dot_*` | `~/.*` | e.g. `dot_zshrc` → `~/.zshrc`, `dot_gitconfig` → `~/.gitconfig` |
| `private_dot_config/` | `~/.config/` | private permissions |
| `*.tmpl` | rendered file | Go templates |

Bootstrap config lives at the source root and is consumed in place (not deployed to `$HOME`):

- **`bootstrap.sh`** - universal first-run script and the single source of truth for provisioning, invoked by the Dockerfile: mise → chezmoi init → partial apply of `miserc.toml` → `mise bootstrap --yes` → `chezmoi apply`. Environment: `CHEZMOI_PROFILE` (default `dev`, also sets `MISE_ENV`), `DOTFILES_REPO`, `DOTFILES_BRANCH`; pass `--no-login-shell` to skip starting zsh at the end (used by Docker builds)
- **`mise.toml`** - `[tools]`, `[bootstrap.repos]`, `[bootstrap.user]`
- **`mise.linux.toml`** - Linux apt packages; loaded when `auto_env` is enabled
- **`private_dot_config/mise/miserc.toml`** -> `~/.config/mise/miserc.toml` with `auto_env = true`

Partial apply of `miserc.toml` before `mise bootstrap` is required: `auto_env` must be active so `mise.linux.toml` installs `git`, `zsh`, and `build-essential` before the full `chezmoi apply`.

The `Dockerfile` is a thin wrapper over `bootstrap.sh`: it only installs `curl`, copies the script in, and runs it with `--no-login-shell` under the chosen `PROFILE`. Everything else lives in `bootstrap.sh`, so there is no duplicated provisioning logic.

To provision a machine manually for the dev profile:

```sh
CHEZMOI_PROFILE=dev bash bootstrap.sh
```

## SSH and git identity (manual, per container)

SSH keys are **not** stored in the repository and are **not** managed by any script. Each container generates its own keys by hand and registers them with GitHub. The Git signing key is configured globally in the dev container only.

### Dev container

After `chezmoi apply`, run once:

```sh
# 1. Authentication key — gh creates ~/.ssh/id_ed25519 and registers it; leave the passphrase empty
gh auth login # choose SSH protocol (or HTTPS)

# 2. Signing key (separate from auth); leave the passphrase empty
ssh-keygen -t ed25519 -f ~/.ssh/signing_key
gh ssh-key add ~/.ssh/signing_key.pub --type signing

# 3. Git identity — global config lives in the dev container only
git config --global user.name  "<name>"
git config --global user.email "<email>"
git config --global user.signingkey "~/.ssh/signing_key"

# 4. Verify GitHub's SSH accepts this key and the signing registration
ssh -T git@github.com
```

Notes:

- `~/.gitconfig` is managed by chezmoi (it enables `gpg.format = ssh` and `commit.gpgsign = true`). Personal values set via `git config --global` are appended after apply and survive until the next `chezmoi apply`, which resets the file — re-run the `git config --global` lines if that happens.
- `user.signingkey` points at the **private** key path, so signing works without an ssh-agent.
- No `~/.ssh/config` is required: `id_ed25519` is the default key name SSH tries for `git@github.com`.

### Sandbox container

The project folder (including its `.git/config`) is mounted into the sandbox at `~/workspace`, but the sandbox has **no** git identity: `user.name`, `user.email`, and `user.signingkey` live only in the dev container's `~/.gitconfig`, which is never applied to the sandbox. Because commits are signed, the sandbox **cannot** sign commits or push — use the dev container for that. As a side effect, nothing personal is exposed through the mounted repository.

The workspace lives at `~/workspace` (inside `$HOME`) rather than at the filesystem root, because mise resolves the profile tool configs (`~/mise.toml`, `~/mise.dev.toml`, `~/mise.sandbox.toml`, `~/mise.linux.toml`) by walking up from the current directory and stops at `$HOME`. Starting the shell from `/root/workspace` makes those tools available immediately.

## Shell (zsh)

```
~/.zshrc                          ← dot_zshrc
  └── ~/.config/zsh/init.zsh      ← private_dot_config/zsh/init.zsh
        ├── env.d/00-mise.zsh     ← mise activate
        └── plugins/              ← Oh My Zsh theme and plugin list
```

Oh My Zsh and plugins are cloned by `mise bootstrap` into `~/.oh-my-zsh`. Plugin config is in `private_dot_config/zsh/plugins/`.

## Components

- **Neovim** - [AstroNvim](https://github.com/AstroNvim/template) template cloned to `~/.config/nvim` by mise; overrides in `private_dot_config/nvim/lua/`
- **tmux** - modular config in `private_dot_config/tmux/conf.d/`; `10-options.conf.tmpl` sets `default-shell zsh`
- **lazygit** - `private_dot_config/lazygit/config.yml`
- **Tools** - managed in `mise.toml` (gh, neovim, tmux, uv, pnpm, ripgrep, jq, lazygit, …)

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
