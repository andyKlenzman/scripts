# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repo is a collection of personal shell scripts for everyday automations on macOS.

## Setup

Make all scripts executable:
```bash
chmod +x ~/scripts/*.sh
```

Add the scripts directory to `PATH` in `~/.zshrc`:
```bash
export PATH="$HOME/scripts:$PATH"
```

## Scripts

- **`generate-tree.sh`** — Opens a macOS folder picker (via `osascript`) and runs `tree -L 2 -a` on the selected directory. Requires the `tree` CLI tool.
- **`list-scripts.sh`** — (In progress / empty)

## Conventions

- All scripts are `bash` and use the `.sh` extension.
- Scripts that need user interaction on macOS use `osascript` for GUI dialogs.
