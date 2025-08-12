#!/bin/bash

show_nvim() {
	cat <<EOF
✍🏻 NVIM CHEATSHEET

🧭 Movements and commands without plugins

1. Add attribute
F>  - move cursor to ">"
i   - insert before ">"

2. Change content inside tag
F>  - move cursor to ">"
a   - insert after ">"

3. Change tag content (name + attributes)
ci< - change content between <...>
vi< - select content between <...>

4. Change inside tag
cit - remove all between <tag>...</tag>
vit - select all between <tag>...</tag>

5. Change the entire tag
cat - remove entire tag and start inserting in its place
vat - select entire tag

6. Go to pair tag
% - jump to corresponding opening/closing tag

EOF
}
