#!/bin/bash

# finds the largest text files in a directory, excluding .git, .svn
# and .hg folders

find . -type f -not -iwholename '*.git*' -not -iwholename '*.svn*' \
-not -iwholename '*.hg*' -exec file {} \; | grep text | cut -d: -f1 \
| xargs ls -s | sort -n -r | head -15
