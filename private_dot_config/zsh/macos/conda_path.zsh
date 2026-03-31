export PATH="/opt/homebrew/anaconda3/bin:/opt/anaconda3/bin:$PATH"

# Выбираем только одну установку conda для инициализации
if [[ -f "/opt/anaconda3/bin/conda" ]]; then
  eval "$(/opt/anaconda3/bin/conda shell.zsh hook)"
elif [[ -f "/opt/homebrew/anaconda3/bin/conda" ]]; then
  eval "$(/opt/homebrew/anaconda3/bin/conda shell.zsh hook)"
fi
