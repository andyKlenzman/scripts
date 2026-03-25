#!/bin/bash

STORE="$HOME/.scriptvariables"
touch "$STORE"

case "$1" in
    set)
        grep -v "^$2=" "$STORE" > "$STORE.tmp" && mv "$STORE.tmp" "$STORE"
        echo "$2=$3" >> "$STORE"
        echo "Saved: $2=$3"
        ;;
    get)
        grep "^$2=" "$STORE" | cut -d'=' -f2-
        ;;
    list)
        cat "$STORE"
        ;;
    delete)
        grep -v "^$2=" "$STORE" > "$STORE.tmp" && mv "$STORE.tmp" "$STORE"
        echo "Deleted: $2"
        ;;
    *)
        echo "Usage: variablestore.sh set|get|list|delete [KEY] [VALUE]"
        ;;
esac
