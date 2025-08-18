#!/bin/bash

local SYSTEM_NAME=$(uname)

if [[ $SYSTEM_NAME == "Darwin" ]]; then
  source "$HOME/.config/zsh/macos/ssh.sh"
elif [[ $SYSTEM_NAME == "Linux" ]]; then
  source "$HOME/.config/zsh/linux/ssh.sh"
fi
