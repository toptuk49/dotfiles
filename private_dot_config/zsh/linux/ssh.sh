#!/bin/bash
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock

rm -f "$SSH_AUTH_SOCK"
(socat UNIX-LISTEN:"$SSH_AUTH_SOCK",fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent" >/dev/null 2>&1 &)
