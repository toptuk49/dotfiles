ZSH_CONFIG_HOME="${0:a:h}"

for f in $ZSH_CONFIG_HOME/env.d/*.zsh; do
  source "$f"
done

source "$ZSH_CONFIG_HOME/plugins/init.zsh"

source "$ZSH_CONFIG_HOME/ssh/init.zsh"

source "$ZSH_CONFIG_HOME/git/init.zsh"

alias pn="pnpm"

poetry config virtualenvs.in-project true
