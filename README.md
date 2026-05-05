# Scripts

A growing, portable collection of personal macOS automations. Each tool lives in its own subdirectory. One `setup.sh` gets everything running on a new machine.

---

## Setup on a New System

```bash
git clone <repo-url> ~/scripts
chmod +x ~/scripts/setup.sh
~/scripts/setup.sh
source ~/.zshrc
```

That's it. `setup.sh` writes a dynamic PATH loop to `~/.zshrc` and runs each tool's setup interactively.

---

## Tools

| Tool | Description | Commands |
|------|-------------|----------|
| `blog/` | Hugo blog authoring and publishing | `blog-new <slug>`, `blog-publish [message]` |
| `jlink/` | JLink firmware flashing | `flash-firmware` |

---

## Adding a New Tool

1. Create a `<toolname>/` directory in the repo root
2. Write `<toolname>/setup.sh` — reads/writes `~/.config/scripts/<toolname>.conf`
3. Place tool scripts in `<toolname>/`
4. Register `<toolname>/setup.sh` in the master `setup.sh`
5. Add a row to the Tools table above

The PATH loop in `~/.zshrc` picks up the new subdirectory automatically — no further shell config needed.

---

## Config

Tool configuration lives in `~/.config/scripts/` as simple `KEY=VALUE` files:

```
~/.config/scripts/
    blog.conf
    jlink.conf
```

Run `setup.sh` again at any time to reconfigure.
