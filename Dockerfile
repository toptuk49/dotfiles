FROM ubuntu:latest

ARG PROFILE
ARG DOTFILES_BRANCH

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root
ENV CHEZMOI_PROFILE=$PROFILE
ENV MISE_ENV=$PROFILE
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN apt update && apt install -y curl

COPY bootstrap.sh /usr/local/bin/bootstrap.sh

RUN DOTFILES_REPO="https://github.com/toptuk49/dotfiles.git" \
    DOTFILES_BRANCH="$DOTFILES_BRANCH" \
    bootstrap.sh --no-login-shell

WORKDIR $HOME/workspace
ENTRYPOINT ["zsh", "-l"]
