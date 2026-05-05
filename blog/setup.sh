#!/bin/bash

source "$(dirname "$0")/../lib/common.sh"

CONFIG_DIR="$HOME/.config/scripts"
CONFIG_FILE="$CONFIG_DIR/blog.conf"

mkdir -p "$CONFIG_DIR"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    echo "Current blog config:"
    echo "  BLOG_PATH=$BLOG_PATH"
    echo ""
fi

read -rp "Blog repo path [${BLOG_PATH:-e.g. /Users/you/Development/andy.blog}]: " input
[ -n "$input" ] && BLOG_PATH="$input"

if [ ! -d "$BLOG_PATH" ]; then
    echo "Warning: Directory does not exist: $BLOG_PATH"
    echo "(Config saved anyway — make sure the path is correct before using blog commands)"
fi

echo "BLOG_PATH=$BLOG_PATH" > "$CONFIG_FILE"
echo "Blog config saved to $CONFIG_FILE"
