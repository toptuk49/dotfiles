SYSTEM_NAME=$(uname)

if [[ $SYSTEM_NAME == "Darwin" ]]; then
  source "$HOME/.config/zsh/macos/config_path.zsh"
fi
