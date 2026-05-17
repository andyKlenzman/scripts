#!/bin/bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

debug() {
    [ "${DEBUG:-0}" = "1" ] && echo "[debug] $*" >&2
}

require_config() {
    local tool="$1"
    local conf="$HOME/.config/scripts/${tool}.conf"
    if [ ! -f "$conf" ]; then
        echo "Error: No config found for '${tool}'. Run setup.sh first." >&2
        exit 1
    fi
    # shellcheck source=/dev/null
    source "$conf"
    debug "Loaded config: $conf"
}
