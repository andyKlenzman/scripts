#!/bin/bash

SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Available scripts in $SCRIPTS_DIR:"
echo ""

for script in "$SCRIPTS_DIR"/*.sh; do
    name="$(basename "$script")"
    if [ "$name" != "list-scripts.sh" ]; then
        echo "  $name"
    fi
done
