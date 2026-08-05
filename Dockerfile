FROM ubuntu:latest

ARG PROFILE
ARG DOTFILES_BRANCH

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root

RUN apt update && apt install -y curl

RUN curl -fsSL https://mise.run | sh
ENV PATH="${HOME}/.local/bin:${HOME}/.local/share/mise/shims:${PATH}"

RUN mise use -g "chezmoi@latest"

ENV CHEZMOI_PROFILE=$PROFILE
ENV MISE_ENV=$PROFILE

RUN test -n "$DOTFILES_BRANCH" \
 && chezmoi init --branch "$DOTFILES_BRANCH" toptuk49/dotfiles \
 && cd "$(chezmoi source-path)" \
 && mise trust \
 && chezmoi apply -P ~/.config/mise/miserc.toml \
 && mise bootstrap --yes \
 && chezmoi apply

WORKDIR /workspace
ENTRYPOINT ["zsh", "-l"]
