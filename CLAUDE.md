# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A growing, portable collection of personal macOS shell automations. Each tool lives in its own subdirectory and is automatically available on PATH after a one-time `setup` run.

## Repository Layout

```
/
├── setup              # Bootstrap — run once on a new machine
├── scripts            # Lists all available tools and commands
├── lib/
│   └── common         # Shared utilities sourced by all tool scripts
├── blog/              # Blog tool (functional tool example)
├── misc/              # Unsorted / one-off scripts
└── dev-docs/          # Specs, TODO, and this file's sibling
```

The root contains only infrastructure (`setup`, `scripts`, `lib/`) and tool subdirectories. Everything else lives in `misc/`.

## Key Commands

```bash
./setup             # First-time setup (idempotent — safe to re-run)
source ~/.zshrc     # Activate PATH after setup
scripts             # List all available tools and commands
scripts --debug     # Show repo path, tool PATH entries, and config file status
```

## How Setup Works (Technical)

### 1. PATH registration (`setup`)

`setup` checks `~/.zshrc` for a sentinel comment line:

```
# scripts repo — auto-load all tool subdirectories
```

If not found, it appends this block to `~/.zshrc`:

```bash
# scripts repo — auto-load all tool subdirectories
SCRIPTS_DIR="/absolute/path/to/repo"
export PATH="$SCRIPTS_DIR:$PATH"
for dir in "$SCRIPTS_DIR"/*/; do
    [ -d "$dir" ] && export PATH="$dir:$PATH"
done
typeset -U PATH
```

- `$SCRIPTS_DIR` is the absolute path baked in at setup time
- The loop adds every immediate subdirectory to PATH — new tools appear automatically without re-running setup
- `typeset -U PATH` is zsh-native deduplication; prevents PATH from growing on each `.zshrc` source
- The sentinel comment makes the check idempotent — running `setup` again skips this step

### 2. Tool setup delegation

After PATH registration, `setup` calls each tool's setup script in sequence:

```bash
bash "$SCRIPT_DIR/blog/blog-setup"
# add new tools here:
# bash "$SCRIPT_DIR/<toolname>/<toolname>-setup"
```

To add a new tool to the bootstrap, append its setup call here.

### 3. `lib/common` — shared runtime

Every tool script sources this at the top:

```bash
source "$(dirname "$0")/../lib/common"
```

It exports:
- `$SCRIPTS_DIR` — absolute path to the repo root (derived from `common`'s own location)
- `debug()` — prints `[debug] ...` to stderr when `DEBUG=1`
- `require_config <tool>` — sources `~/.config/scripts/<tool>.conf`, exits with an error if missing

### 4. XDG config

Each tool stores its config in `~/.config/scripts/<toolname>.conf` as plain `KEY=VALUE` pairs. The `<toolname>-setup` script writes this file interactively and is idempotent. Tool scripts source the config via `require_config` at runtime — no hardcoded paths anywhere.

### 5. Cron scripts

Scripts called by cron run in a minimal environment with no PATH and no `.zshrc`. They must use absolute binary paths (`/usr/bin/git`, `/usr/bin/logger`, `/usr/bin/osascript`) and source config by absolute path. Logs go to Console.app via `logger -t "scripts.<toolname>"`.

## Naming Convention

| Type | Convention | Example |
|------|-----------|---------|
| User-facing tool scripts | `<toolname>-<action>` (no extension) | `blog-new`, `blog-publish` |
| Tool setup | `<toolname>-setup` (no extension) | `blog-setup` |
| Shared/internal | `<name>` no extension or keep context | `common`, `setup` |

## Adding a New Tool

1. Create `<toolname>/` directory
2. Write `<toolname>/<toolname>-setup` — reads/writes `~/.config/scripts/<toolname>.conf`
3. Write tool scripts named `<toolname>-<action>`, sourcing `../lib/common` and calling `require_config <toolname>`
4. Register `<toolname>/<toolname>-setup` in the root `setup` script
5. Add a row to README.md Tools table
6. `chmod +x <toolname>/<toolname>-*`
