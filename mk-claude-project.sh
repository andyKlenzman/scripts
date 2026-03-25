#!/bin/bash

workspace=$(sh variablestore.sh get claude-workspace)

if [ -z "$workspace" ]; then
    echo "Error: 'claude-workspace' not set. Run: variablestore.sh set claude-workspace /your/path"
    exit 1
fi

read -p "Project name: " input

name=$(echo "$input" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
dir="${workspace}/$(date +%Y-%m-%d)-${name}"

mkdir "$dir"
touch "$dir/SKILLS.md"

echo "Created: $dir"
