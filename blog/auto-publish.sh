#!/bin/bash

# Called by cron — must use absolute paths, no PATH or .zshrc available

CONFIG="$HOME/.config/scripts/blog.conf"
LOG_TAG="scripts.blog"

if [ ! -f "$CONFIG" ]; then
    /usr/bin/logger -t "$LOG_TAG" "auto-publish: config not found at $CONFIG"
    exit 1
fi

# shellcheck source=/dev/null
source "$CONFIG"

if [ ! -d "$BLOG_PATH" ]; then
    /usr/bin/logger -t "$LOG_TAG" "auto-publish: blog path not found: $BLOG_PATH"
    exit 1
fi

cd "$BLOG_PATH" || exit 1

# Exit silently if no changes
if /usr/bin/git diff --quiet && /usr/bin/git diff --cached --quiet; then
    exit 0
fi

/usr/bin/git add -A
/usr/bin/git commit -m "auto-publish"
PUSH_OUTPUT=$(/usr/bin/git push 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    /usr/bin/logger -t "$LOG_TAG" "auto-publish: pushed successfully"
    /usr/bin/osascript -e 'display notification "Changes published successfully" with title "Script Library" subtitle "Blog Auto-Publish"'
else
    /usr/bin/logger -t "$LOG_TAG" "auto-publish: push failed — $PUSH_OUTPUT"
    /usr/bin/osascript -e "display notification \"Push failed — check Console.app for details\" with title \"Script Library\" subtitle \"Blog Auto-Publish Error\""
fi

exit $EXIT_CODE
