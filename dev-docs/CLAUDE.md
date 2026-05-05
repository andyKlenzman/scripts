# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What This Repo Is

A growing collection of personal macOS shell automations. Each tool is self-contained in its own subdirectory. The repo is designed to be cloned on any machine and set up with a single command.

## Structure

```
/
├── setup.sh               ← Master setup — run this on a new machine
├── <toolname>/
│   ├── setup.sh           ← Tool-specific config setup
│   └── *.sh               ← Tool scripts (auto-added to PATH)
├── dev-docs/
│   ├── SPEC.md
│   ├── TODO.md
│   └── CLAUDE.md          ← this file
└── README.md
```

## PATH Convention

`setup.sh` writes a dynamic loop to `~/.zshrc` that adds every subdirectory to PATH:

```bash
for dir in "$SCRIPTS_DIR"/*/; do
  export PATH="$dir:$PATH"
done
```

New tool subdirectories are picked up automatically — never manually edit PATH for new tools.

## Config Convention (XDG)

All tool config lives under `~/.config/scripts/` as `KEY=VALUE` files:

- `~/.config/scripts/blog.conf`
- `~/.config/scripts/jlink.conf`

Each tool's `setup.sh` is responsible for writing its own `.conf` file interactively. Scripts source their config at runtime: `source ~/.config/scripts/<tool>.conf`.

Never hardcode paths in scripts. Always read from config.

## Adding a New Tool — Checklist

- [ ] Create `<toolname>/` directory
- [ ] Write `<toolname>/setup.sh` that writes `~/.config/scripts/<toolname>.conf`
- [ ] Write tool scripts in `<toolname>/`, sourcing config at the top
- [ ] Register `<toolname>/setup.sh` in master `setup.sh`
- [ ] Add tool to README.md Tools table
- [ ] Make all scripts executable: `chmod +x <toolname>/*.sh`

## What Was Removed

- `variablestore.sh` — replaced by XDG config (`~/.config/scripts/`)

## Conventions

- All scripts are `bash` with `.sh` extension
- Scripts that need GUI dialogs on macOS use `osascript`
- `setup.sh` scripts must be idempotent (safe to run multiple times)
- No hardcoded absolute paths — all paths come from XDG config
