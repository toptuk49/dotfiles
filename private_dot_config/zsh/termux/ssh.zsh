export SSH_AGENT_SOCK="$HOME/.ssh/ssh-agent.termux.sock"

if [[ -S "$SSH_AGENT_SOCK" ]]; then
  if ss -a 2>/dev/null | grep -q "$SSH_AGENT_SOCK" ||
    ps -p "$SSH_AGENT_PID" >/dev/null 2>&1; then
    export SSH_AUTH_SOCK="$SSH_AGENT_SOCK"
  else
    rm -f "$SSH_AGENT_SOCK"
    ssh-agent -a "$SSH_AGENT_SOCK" >/dev/null
    export SSH_AUTH_SOCK="$SSH_AGENT_SOCK"
    export SSH_AGENT_PID=$!
  fi
else
  ssh-agent -a "$SSH_AGENT_SOCK" >/dev/null
  export SSH_AUTH_SOCK="$SSH_AGENT_SOCK"
  export SSH_AGENT_PID=$!
fi

AUTH_PRIMARY="$HOME/.ssh/android-authentication-primary"
AUTH_MISC="$HOME/.ssh/android-authentication-misc"
SIGNING_PRIMARY="$HOME/.ssh/android-signing-primary"
SIGNING_MISC="$HOME/.ssh/android-signing-misc"

MISSING_KEYS=()

[[ ! -f "$AUTH_PRIMARY" ]] && MISSING_KEYS+=("$AUTH_PRIMARY")
[[ ! -f "$AUTH_MISC" ]] && MISSING_KEYS+=("$AUTH_MISC")
[[ ! -f "$SIGNING_PRIMARY" ]] && MISSING_KEYS+=("$SIGNING_PRIMARY")
[[ ! -f "$SIGNING_MISC" ]] && MISSING_KEYS+=("$SIGNING_MISC")

if [[ ${#MISSING_KEYS[@]} -gt 0 ]]; then
  echo "Отсутствуют следующие SSH ключи:"
  for key in "${MISSING_KEYS[@]}"; do
    echo "   - $key"
  done
  echo ""
  echo "Создайте недостающие ключи:"
  echo "  ssh-keygen -t ed25519 -f ~/.ssh/android-authentication-primary -C 'android-auth-primary'"
  echo "  ssh-keygen -t ed25519 -f ~/.ssh/android-authentication-misc -C 'android-auth-misc'"
  echo "  ssh-keygen -t ed25519 -f ~/.ssh/android-signing-primary -C 'android-signing-primary'"
  echo "  ssh-keygen -t ed25519 -f ~/.ssh/android-signing-misc -C 'android-signing-misc'"
  echo ""
  echo "Добавьте публичные ключи (.pub) в соответствующие GitHub аккаунты:"
  echo "  - PRIMARY: $(cat ~/.config/git/.gitconfig-primary 2>/dev/null | grep email | cut -d'=' -f2 | tr -d ' \"' || echo 'primary-email')"
  echo "  - MISC: $(cat ~/.config/git/.gitconfig-misc 2>/dev/null | grep email | cut -d'=' -f2 | tr -d ' \"' || echo 'misc-email')"
  echo ""
  echo "После добавления проверьте подключение:"
  echo "  ssh -T git@github.com"
fi

[[ -f "$AUTH_PRIMARY" ]] && ssh-add "$AUTH_PRIMARY" 2>/dev/null
[[ -f "$AUTH_MISC" ]] && ssh-add "$AUTH_MISC" 2>/dev/null
[[ -f "$SIGNING_PRIMARY" ]] && ssh-add "$SIGNING_PRIMARY" 2>/dev/null
[[ -f "$SIGNING_MISC" ]] && ssh-add "$SIGNING_MISC" 2>/dev/null
