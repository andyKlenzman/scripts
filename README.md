

# Scripts

This repo contains scripts for everyday automations.

Run this command to make all scripts executable.

```bash
chmod +x ~/scripts/*.sh
```

Add the scripts directory to path to make them callable from the terminal.

```bash
nano ~/.zshrc
```

Add the following command and the path will be added to your path at the start of every terminal session

```bash
export PATH="$HOME/scripts:$PATH"
```

## variablestore.sh

Saves and reads persistent variables in `~/.scriptvariables`. Used by other scripts to share configuration.

```bash
variablestore.sh set KEY VALUE
variablestore.sh get KEY
variablestore.sh list
variablestore.sh delete KEY
```

### Required variables

| Variable | Beschreibung |
|---|---|
| `claude-workspace` | Base directory where `mk-claude-project.sh` creates new projects |

Set it once:
```bash
variablestore.sh set claude-workspace /path/to/your/workspace
```


