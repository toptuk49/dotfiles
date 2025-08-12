#!/bin/bash

show_figma() {
	cat <<EOF
🎨 FIGMA CHEATSHEET

The cheatsheet is aimed at the main way to work with figma in the context
of frontend development.

📤 Extract atoms styles

If there is a need to get general styles for a page, such as fonts or colors,
there are two working ways to get them depending on the situation.

1. The layout has good architecture ✅

Assets -> Local Styles

2. The layout hasn't good architecture 👎

- Download plugin 'Design Lint' and open it;
- Errors List will show you all style groups you need.

EOF
}
