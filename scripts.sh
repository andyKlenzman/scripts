#!/bin/bash

source "$(dirname "$0")/lib/common.sh"

EXCLUDE=("lib" "dev-docs")

is_excluded() {
    local name="$1"
    for ex in "${EXCLUDE[@]}"; do
        [ "$name" = "$ex" ] && return 0
    done
    return 1
}

echo ""
echo "Script Library"
echo "=============="

for tool_dir in "$SCRIPTS_DIR"/*/; do
    tool="$(basename "$tool_dir")"
    is_excluded "$tool" && continue

    echo ""
    echo "  ${tool}/"
    for script in "$tool_dir"*.sh; do
        [ -f "$script" ] || continue
        cmd="$(basename "$script" .sh)"
        echo "    $cmd"
    done
done

echo ""

[ "${1:-}" != "--debug" ] && exit 0

echo "--- Debug Info ---"
echo "Repo:    $SCRIPTS_DIR"
echo "Config:  $HOME/.config/scripts/"
echo ""
echo "PATH entries from this repo:"
for tool_dir in "$SCRIPTS_DIR"/*/; do
    tool="$(basename "$tool_dir")"
    is_excluded "$tool" && continue
    echo "  $tool_dir"
done

echo ""
echo "Config files:"
config_dir="$HOME/.config/scripts"
for tool_dir in "$SCRIPTS_DIR"/*/; do
    tool="$(basename "$tool_dir")"
    is_excluded "$tool" && continue
    conf="${config_dir}/${tool}.conf"
    if [ -f "$conf" ]; then
        echo "  ${tool}.conf ✓"
    else
        echo "  ${tool}.conf ✗ (missing — run setup.sh)"
    fi
done
echo ""
