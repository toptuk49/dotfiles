#!/bin/bash

show_ssh-agent() {
    cat <<EOF
🔑 SSH AGENT CHEATSHEET

🛡️ About

I use Bitwarden as a secret manager. You can configure it to store
and use SSH keys by reading the article:

https://bitwarden.com/help/ssh-agent/

✨ WSL features

If you are using WSL, you run Bitwarden Desktop in the context
of your Windows system. Therefore, you cannot access your keys
in the context of a Linux system.

Why? Because the SSH agent is a process that listens to a socket.
On Windows systems, sockets are implemented as Named Pipes. So,
to work with the SSH agent in WSL, we need a way to set up a
bridge between these two systems.

⚙️ WSL setup

For more details read the article:

https://dev.to/andrewdoesinfra/using-windows-ssh-agent-in-wsl2-a-complete-guide-50oi

1. Enable SSH agent in your secrets manager settings.

2. Clone the tool that helps to establish bridge between Windows and WSL.
Inside WSL terminal:

git clone https://github.com/jstarks/npiperelay

3. Install go language:

brew install go
# or
mise use -g go@latest

4. Build npiperelay inslide WSL terminal and store it in Windows system:

cd npiperelay
go get -d github.com/jstarks/npiperelay
GOOS=windows go build -o /mnt/c/Users/<username>/go/bin/npiperelay.exe github.com/jstarks/npiperelay

5. Create a Linux symlink to a Windows npiperelay:

sudo ln -s /mnt/c/Users/<username>/go/bin/npiperelay.exe /usr/local/bin/npiperelay.exe

6. Install socat tool that establishes the connection between systems:

brew install socat

7. And set up the relay script. You can put it for example in your
.zshrc or .bashrc file. It works with every secrets manager.

#!/bin/bash
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock

# Check if the socket already exists
ss -a | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0 ]; then
    # Start a new socat process
    rm -f $SSH_AUTH_SOCK
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi

EOF
}
