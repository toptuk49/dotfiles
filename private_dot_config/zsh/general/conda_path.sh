#!/bin/bash

SYSTEM_NAME=$(uname)

if [[ $SYSTEM_NAME == "Darwin" ]]; then
	source "$HOME/.config/zsh/macos/conda_path.sh"
fi
