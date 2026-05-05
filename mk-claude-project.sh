#!/bin/bash

source "$(dirname "$0")/lib/common.sh"

CONFIG_FILE="$HOME/.config/scripts/mk-claude-project.conf"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

if [ -z "${CLAUDE_WORKSPACE:-}" ]; then
    read -rp "Claude workspace path (where new projects are created): " CLAUDE_WORKSPACE
    mkdir -p "$HOME/.config/scripts"
    echo "CLAUDE_WORKSPACE=$CLAUDE_WORKSPACE" > "$CONFIG_FILE"
    echo "Saved to $CONFIG_FILE"
fi

if [ ! -d "$CLAUDE_WORKSPACE" ]; then
    echo "Error: Workspace directory does not exist: $CLAUDE_WORKSPACE" >&2
    exit 1
fi

read -rp "Project name: " input

name=$(echo "$input" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
dir="${CLAUDE_WORKSPACE}/$(date +%Y-%m-%d)-${name}"

mkdir "$dir"
touch "$dir/SKILLS.md"

echo "Created: $dir"
