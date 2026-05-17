# Scripts

A growing, portable collection of personal macOS automations. Each tool lives in its own subdirectory. One `setup` script gets everything running on a new machine.

---

## Setup on a New System

```bash
git clone <repo-url> ~/DevelopmentTools/scripts
bash ~/DevelopmentTools/scripts/setup
source ~/.zshrc
```

`setup` writes a dynamic PATH loop to `~/.zshrc` that includes every tool subdirectory automatically, then runs each tool's interactive config setup. Safe to re-run at any time.

---

## Using the Script Library

```bash
scripts            # list all available tools and commands
scripts --debug    # show repo path, PATH entries, and config file status
```

---

## Adding a New Tool

Say you want to add a tool called `weather`. Here's what that looks like:

1. **Create the directory:** `weather/` in the repo root
2. **Create a setup script:** `weather/weather-setup` — this asks the user for any config values it needs (e.g. API keys, file paths) and saves them to `~/.config/scripts/weather.conf`
3. **Create the tool scripts:** e.g. `weather/weather-now`, `weather/weather-forecast` — each one reads its config and does the work
4. **Register the setup:** add `bash "$SCRIPT_DIR/weather/weather-setup"` to the root `setup` script so it runs on first install
5. **Document it:** add a row to the Tools table above

The new `weather/` directory is picked up by the PATH loop automatically — no shell config changes needed.

---

## Config

Each tool stores config in `~/.config/scripts/` as simple `KEY=VALUE` files:

```
~/.config/scripts/
    blog.conf
```

Run a tool's `-setup` command to configure or reconfigure it.
