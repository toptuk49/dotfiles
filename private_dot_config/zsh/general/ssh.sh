#!/bin/bash

SYSTEM_NAME=$(uname)
ENV_TYPE="unknown"

if [[ -n "$ANDROID_ROOT" ]]; then
  source "$HOME/.config/zsh/termux/ssh.sh"
  return 0
fi

if [[ $SYSTEM_NAME == "Darwin" ]]; then
  source "$HOME/.config/zsh/macos/ssh.sh"
elif [[ $SYSTEM_NAME == "Linux" ]]; then
  source "$HOME/.config/zsh/linux/ssh.sh"
fi
