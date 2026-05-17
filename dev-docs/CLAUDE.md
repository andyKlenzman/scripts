# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Structure

```
/
├── setup                       ← Master bootstrap — run once on a new machine
├── scripts                     ← Lists all available tools and commands
├── lib/
│   └── common                  ← Shared utilities sourced by all tool scripts
├── <toolname>/
│   ├── <toolname>-setup        ← Interactive config writer for this tool
│   └── <toolname>-<action>     ← Tool scripts (auto-added to PATH)
├── misc/                       ← Unsorted / one-off scripts
├── dev-docs/                   ← Specs, TODO, CLAUDE.md
└── README.md
```

The root contains only infrastructure and tool directories. One-off or unsorted scripts go in `misc/`.

## How the Setup Mechanism Works

### PATH registration

`setup` appends a block to `~/.zshrc` once, guarded by a sentinel comment to ensure idempotency:

```bash
# scripts repo — auto-load all tool subdirectories
SCRIPTS_DIR="/absolute/path/to/repo"
export PATH="$SCRIPTS_DIR:$PATH"
for dir in "$SCRIPTS_DIR"/*/; do
    [ -d "$dir" ] && export PATH="$dir:$PATH"
done
typeset -U PATH
```

Key points for a developer changing this:
- `$SCRIPTS_DIR` is the repo's absolute path, baked in at setup time by `setup` itself
- The glob `*/` means every immediate subdirectory is added — adding a new tool directory requires no changes to this block
- `typeset -U PATH` is zsh-specific; it deduplicates PATH entries automatically on each shell start
- To change the sentinel string, update both `PATH_MARKER` in `setup` and remove the old block from `~/.zshrc` before re-running

### Shared runtime (`lib/common`)

All tool scripts source `lib/common` using a path relative to their own location:

```bash
source "$(dirname "$0")/../lib/common"
```

`lib/common` derives `$SCRIPTS_DIR` from its own file path:

```bash
SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
```

This means `$SCRIPTS_DIR` is always correct regardless of how or from where a tool script is invoked.

### XDG Config

Config lives in `~/.config/scripts/<toolname>.conf` as plain `KEY=VALUE`. Each tool's `-setup` script writes this file interactively and is idempotent. Tool scripts load config at runtime via `require_config`:

```bash
require_config blog   # sources ~/.config/scripts/blog.conf, exits if missing
```

### Cron scripts

Cron runs scripts in a minimal environment — no PATH, no `.zshrc`. Any script called by cron must:
- Use absolute binary paths: `/usr/bin/git` not `git`
- Source config by absolute path, not via `require_config`
- Log via `logger -t "scripts.<toolname>"` (visible in Console.app)

## Naming Convention

All user-facing scripts: `<toolname>-<action>`, no file extension. Internal/shared files (`setup`, `lib/common`) have no extension either. No `.sh` anywhere.

## Adding a New Tool — Checklist

- [ ] Create `<toolname>/` directory
- [ ] Write `<toolname>/<toolname>-setup` — writes `~/.config/scripts/<toolname>.conf`
- [ ] Write tool scripts as `<toolname>-<action>`, sourcing `../lib/common`
- [ ] Register `<toolname>/<toolname>-setup` in root `setup`
- [ ] Add tool to README.md Tools table
- [ ] `chmod +x <toolname>/<toolname>-*`
