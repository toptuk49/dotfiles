SYSTEM_NAME=$(uname)
ENV_TYPE="unknown"

if [[ -n "$ANDROID_ROOT" ]]; then
  source "$HOME/.config/zsh/termux/ssh_agent.zsh"
  return 0
fi

if [[ -n "$WSL_DISTRO_NAME" ]]; then
  source "$HOME/.config/zsh/wsl/ssh_agent.zsh"
  return 0
fi

if [[ $SYSTEM_NAME == "Darwin" ]]; then
  source "$HOME/.config/zsh/common/ssh_agent.zsh"
fi

if [[ $SYSTEM_NAME == "Linux" ]]; then
  source "$HOME/.config/zsh/common/ssh_agent.zsh"
fi
