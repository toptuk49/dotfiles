#!/bin/bash

show_cheatsheet() {
	cat <<EOF
🎯 CHEATSHEET CHEATSHEET

Prints cheatsheets for frequently used tools.

📌 Usage: cheatsheet <tool> [-l | --list]

✅ Adding new cheatsheets:

Add tool <tool>.sh script to the ~/.local/bin/cheatsheets-src/cheatsheets folder.
In <tool>.sh script define show_<tool> function with the cheatsheet text.
See the other cheatsheets for formatting references.

EOF
}
