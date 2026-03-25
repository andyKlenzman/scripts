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