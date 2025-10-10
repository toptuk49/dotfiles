#!/bin/bash

show_tmux() {
  cat <<EOF
📚 TMUX CHEATSHEET

🏁 Where to start
It's useful to understand that inside tmux, all keyboard shortcuts
start with the <Leader> key, which is Ctrl + a (Cmd + a on macOS).

💡 Core concepts:
Think of tmux as the town you work in.
- 🏢 Session is the building contains storeys.
- 🪟 Window is the storey of building contains rooms.
- 🚪 Pane is the separate room on the floor. It is your terminal.

🔧 Basic commands:
  tmux                      - start new session
  tmux new -s <name>        - start named session
  tmux attach -t <name>     - connect to the session
  tmux ls                   - show all sessions
  <Leader> + d              - detach from session
  tmux new-window -n <name> - create new window with specific name

🍰 Window management:
  <Leader> + n              - open new window
  <Leader> + q              - close current window
  <Leader> + |              - split window horizontally
  <Leader> + -              - split window vertically
  <Leader> + c              - close current pane

↔️ Resize panes:
  📌 NOTE: If you are working on macOS, you might configure
  your terminal to use Option as Meta key.

  Alt + Left Arrow          - resize pane leftwards
  Alt + Right Arrow         - resize pane rightwards
  Alt + Up Arrow            - resize pane upwards 
  Alt + Down Arrow          - resize pane downwards

🏃‍♂️ Moving between panes:
  <Leader> + h              - select left pane
  <Leader> + j              - select down pane
  <Leader> + k              - select up pane
  <Leader> + l              - select right pane

🔄 Configuration reload:
  <Leader> + r              - reload tmux configuration

EOF
}
