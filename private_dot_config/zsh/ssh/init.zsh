if [[ -n "$WSL_DISTRO_NAME" ]]; then
  source "$ZSH_CONFIG_HOME/ssh/wsl/agent.zsh"
else
  source "$ZSH_CONFIG_HOME/ssh/common/agent_bitwarden.zsh"
fi
