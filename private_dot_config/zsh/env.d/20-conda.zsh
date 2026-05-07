if [[ "$(uname)" == "Darwin" ]]; then
  export PATH="/opt/homebrew/anaconda3/bin:/opt/anaconda3/bin:$PATH"
  if [[ -f "/opt/anaconda3/bin/conda" ]]; then
    eval "$(/opt/anaconda3/bin/conda shell.zsh hook)"
  elif [[ -f "/opt/homebrew/anaconda3/bin/conda" ]]; then
    eval "$(/opt/homebrew/anaconda3/bin/conda shell.zsh hook)"
  fi
fi
