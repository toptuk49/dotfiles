#!/bin/bash

local SYSTEM_NAME=$(uname)

if [[ $SYSTEM_NAME == "Linux" ]]; then
	source "$HOME/.config/zsh/linux/brew_path.sh"
fi
