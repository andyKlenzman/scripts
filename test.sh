#!/bin/bash
# test.sh
if REPO_PATH=$(osascript -e 'POSIX path of (choose folder with prompt "Pick a folder:")'); then
    echo "REPO_PATH: $REPO_PATH"
    tree -L 2 -a "$REPO_PATH"

else
    echo "Cancelled."
fi

