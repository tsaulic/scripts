#!/bin/bash

# finds the largest files in a directory, excluding .git, .svn and .hg folders

find . -type f -not -iwholename '*.git*' -not -iwholename '*.svn*' \
-not -iwholename '*.hg*' -exec ls -s {} \; | sort -n -r | head -10
