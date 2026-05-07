source "$ZSH_CONFIG_HOME/git/autodetect_account.zsh"

autoload -U add-zsh-hook
add-zsh-hook chpwd detect_and_change_account

if [[ -d .git ]]; then
  detect_and_change_account
fi
