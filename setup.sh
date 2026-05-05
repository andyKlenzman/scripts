#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZSHRC="$HOME/.zshrc"
PATH_MARKER="# scripts repo — auto-load all tool subdirectories"

echo ""
echo "=== Script Library Setup ==="
echo ""

# PATH loop
if grep -qF "$PATH_MARKER" "$ZSHRC" 2>/dev/null; then
    echo "PATH already configured, skipping."
else
    cat >> "$ZSHRC" <<EOF

${PATH_MARKER}
SCRIPTS_DIR="${SCRIPT_DIR}"
for dir in "\$SCRIPTS_DIR"/*/; do
    [ -d "\$dir" ] && export PATH="\$dir:\$PATH"
done
EOF
    echo "PATH configured."
fi

echo ""
echo "--- Blog tool setup ---"
bash "$SCRIPT_DIR/blog/setup.sh"

echo ""
echo "All tools configured."
echo "Run: source ~/.zshrc"
echo "Then try:"
echo "  scripts          — list all available commands"
echo "  scripts --debug  — show paths and config status"
echo ""
