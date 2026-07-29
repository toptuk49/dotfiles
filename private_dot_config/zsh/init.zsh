ZSH_CONFIG_HOME="$HOME/.config/zsh"

for f in $ZSH_CONFIG_HOME/env.d/*.zsh(N); do
  source "$f"
done

source "$ZSH_CONFIG_HOME/plugins/init.zsh"

source "$ZSH_CONFIG_HOME/ssh/init.zsh"

source "$ZSH_CONFIG_HOME/git/init.zsh"

alias pn="pnpm"
