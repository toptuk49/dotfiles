# Dotfiles ⚙️

Personal shell, editor, and tooling configurations. The repository is a [chezmoi](https://github.com/twpayne/chezmoi) source state: files are rendered into the home directory on `chezmoi apply`. Machine setup (tools, system packages, external repos) is handled declaratively by [mise bootstrap](https://mise.jdx.dev/dev-tools/bootstrap.html).

No personal data, no secrets, and no secrets manager are involved at render time.

## 🚀 Setup

### Docker provisioning

Pre-built images are published to GHCR from the `main` branch (multi-arch `amd64`/`arm64`); `docker run` pulls them automatically. The image entrypoint is `zsh -l`, working directory `~/workspace`.

```sh
PROJECT=my-project

# Shared volume for the project files (main branch, worktrees) - create once
docker volume create "$PROJECT"

# Dev: full toolchain, git identity configured in the next section;
# the docker socket is mounted to manage the sandbox and other containers
docker run -dit --name "$PROJECT"-dev \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PROJECT":/root/workspace \
    ghcr.io/toptuk49/dotfiles:dev

# Sandbox: minimal environment, no git identity, for working on the project
docker run -dit --name "$PROJECT"-sandbox \
    -v "$PROJECT":/root/workspace \
    ghcr.io/toptuk49/sandbox:dev

# Attach to either container later (docker start <name> first if it is stopped)
docker exec -it "$PROJECT"-dev zsh
docker exec -it "$PROJECT"-sandbox zsh
```

Both containers mount the same volume at `~/workspace`: clone the repository (or a worktree of it) once and the files are visible in both.

### Manual provisioning (without Docker)

A machine with only `curl` can bootstrap itself directly from GitHub. The defaults are the `dev` profile from the `main` branch; edit the two variables to provision the `sandbox` profile or a specific branch:

```sh
PROFILE=dev # or sandbox
BRANCH=main # or a feature branch

CHEZMOI_PROFILE="$PROFILE" DOTFILES_BRANCH="$BRANCH" \
bash -c "$(curl https://raw.githubusercontent.com/toptuk49/dotfiles/$BRANCH/bootstrap.sh)"
```

### SSH and git identity (manual, per container)

SSH keys are **not** stored in the repository and are **not** managed by any script. Each container generates its own keys by hand and registers them with GitHub. The Git signing key is configured globally in the dev container only.

#### Dev container

After `chezmoi apply`, run once:

```sh
# 1. Authentication key - gh creates ~/.ssh/id_ed25519 and registers it; leave the passphrase empty
gh auth login # choose SSH protocol (or HTTPS)

# 2. Signing key (separate from auth); leave the passphrase empty
ssh-keygen -t ed25519 -f ~/.ssh/signing_key
gh ssh-key add ~/.ssh/signing_key.pub --type signing

# 3. Git identity - global config lives in the dev container only
git config --global user.name  "<name>"
git config --global user.email "<email>"
git config --global user.signingkey "~/.ssh/signing_key" # Private key path

# 4. Verify GitHub's SSH accepts this key and the signing registration
ssh -T git@github.com
```

Notes:

- `~/.gitconfig` is managed by chezmoi (it enables `gpg.format = ssh` and `commit.gpgsign = true`). Personal values set via `git config --global` are appended after apply and survive until the next `chezmoi apply`, which resets the file - re-run the `git config --global` lines if that happens.
- `user.signingkey` points at the **private** key path, so signing works without an ssh-agent.
- No `~/.ssh/config` is required: `id_ed25519` is the default key name SSH tries for `git@github.com`.

#### Sandbox container

The project folder (including its `.git/config`) is mounted into the sandbox at `~/workspace`, but the sandbox has **no** git identity: `user.name`, `user.email`, and `user.signingkey` live only in the dev container's `~/.gitconfig`, which is never applied to the sandbox. Because commits are signed, the sandbox **cannot** sign commits or push - use the dev container for that. As a side effect, nothing personal is exposed through the mounted repository.

The workspace lives at `~/workspace` (inside `$HOME`) rather than at the filesystem root, because mise resolves the profile tool configs (`~/mise.toml`, `~/mise.dev.toml`, `~/mise.sandbox.toml`, `~/mise.linux.toml`) by walking up from the current directory and stops at `$HOME`.

## 🪪 Profiles

| Profile     | Role                                                     | Git identity                     |
| ----------- | -------------------------------------------------------- | -------------------------------- |
| **dev**     | Sensitive manual actions: git push, container management | Yes, configured manually         |
| **sandbox** | Development: code editing and related tools              | No - cannot sign commits or push |

Profile tool configs live in `mise.dev.toml` and `mise.sandbox.toml` at the source root.

## 🏡 Architecture

Two layers split responsibilities:

| Layer       | Role                                            |
| ----------- | ----------------------------------------------- |
| **chezmoi** | Dotfiles and static configs                     |
| **mise**    | Tool versions, packages, git repos, login shell |

`bootstrap.sh` is the single source of truth for provisioning: mise -> chezmoi init -> partial apply of `miserc.toml` -> `mise bootstrap --yes` -> `chezmoi apply`. The Dockerfile only installs `curl`, copies the script in, and runs it with `--no-login-shell`, so there is no duplicated provisioning logic.

## 👷‍♂️ Workflow

Edit the source, not deployed files:

```sh
chezmoi cd # open shell in source dir (~/.local/share/chezmoi)
chezmoi edit ~/.zshrc
chezmoi diff
chezmoi apply
chezmoi update # pull source + apply
```

After changing `mise*.toml` or bootstrap config:

```sh
chezmoi cd
mise trust
mise bootstrap
```
