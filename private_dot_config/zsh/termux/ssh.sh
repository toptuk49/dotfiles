#!/bin/bash

export SSH_AGENT_SOCK="$HOME/.ssh/ssh-agent.termux.sock"

if [[ -S "$SSH_AGENT_SOCK" ]]; then
  if ss -a 2>/dev/null | grep -q "$SSH_AGENT_SOCK" ||
    ps -p "$SSH_AGENT_PID" >/dev/null 2>&1; then
    export SSH_AUTH_SOCK="$SSH_AGENT_SOCK"
    return 0
  else
    rm -f "$SSH_AGENT_SOCK"
  fi
fi

ssh-agent -a "$SSH_AGENT_SOCK" >/dev/null
export SSH_AUTH_SOCK="$SSH_AGENT_SOCK"
export SSH_AGENT_PID=$!

AUTH_KEY="$HOME/.ssh/android-authentication"
SIGNING_KEY="$HOME/.ssh/android-signing"

if [[ ! -f "$SIGNING_KEY" ]]; then
  echo "Ключ для подписи коммитов не найден: $SIGNING_KEY"
  echo "Создайте его: ssh-keygen -t ed25519 -f ~/.ssh/android-signing -C 'android-signing'"
  echo "Добавьте ~/.ssh/android-signing.pub в GitHub: Settings → SSH and GPG keys"
  echo "После добавления запустите 'chezmoi apply' еще раз, а затем 'ssh -T git@github.com' для того, чтобы удостовериться, что все работает."
fi

if [[ ! -f "$AUTH_KEY" ]]; then
  echo "Ключ для аутентификации не найден: $AUTH_KEY"
  echo "Создайте его: ssh-keygen -t ed25519 -f ~/.ssh/android-authentication -C 'android-auth'"
  echo "Добавьте ~/.ssh/android-authentication.pub в GitHub: Settings → SSH and GPG keys"
  echo "После добавления запустите 'chezmoi apply' еще раз, а затем 'ssh -T git@github.com' для того, чтобы удостовериться, что все работает."
fi

[[ -f "$AUTH_KEY" ]] && ssh-add "$AUTH_KEY" 2>/dev/null
[[ -f "$SIGNING_KEY" ]] && ssh-add "$SIGNING_KEY" 2>/dev/null
