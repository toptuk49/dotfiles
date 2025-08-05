#!/bin/bash

is_cheatsheets_dir() {
	if [ ! -d "$CHEATSHEETS_DIR" ]; then
		echo "Error: cheatsheets folder is not found: $CHEATSHEETS_DIR" >&2
		exit 1
	fi
}

list_cheatsheets() {
	echo "Available cheatsheets:"
	for file in "$CHEATSHEETS_DIR"/*.sh; do
		if [ -f "$file" ]; then
			filename=$(basename "$file" .sh)
			echo " - $filename"
		fi
	done
}

run_cheatsheet() {
	local cheatsheet=$1
	source "$CHEATSHEETS_DIR/$cheatsheet.sh"

	if type "show_$cheatsheet" >/dev/null 2>&1; then
		"show_$cheatsheet" | less
	else
		echo "Error: Function 'show_$cheatsheet' not found in $CHEATSHEETS_DIR/$cheatsheet.sh" >&2
		exit 1
	fi
}

show_usage() {
	echo "Usage: cheatsheet <tool> [-l | --list]"
}
