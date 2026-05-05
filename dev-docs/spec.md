# Spec: Scripts Repo — Modulare System-Automations-Architektur

## 1. Ziel

Ein wachsendes, portables Repo für persönliche macOS-Automations. Jedes Tool lebt in einem eigenen Unterordner. Ein Master-`setup.sh` richtet alles auf einem neuen System ein. Kein hardcodierter Pfad, keine manuellen `~/.zshrc`-Edits nach dem ersten Setup.

---

## 2. Repo-Struktur

```
/                          ← Repo Root (auf PATH via ~/.zshrc)
├── setup.sh               ← Master-Setup: PATH-Loop + Tool-Setups delegieren
├── scripts.sh             ← Script Library overview: listet alle Tools und Commands
├── lib/
│   └── common.sh          ← Shared utilities: debug(), require_config(), SCRIPTS_DIR
├── blog/
│   ├── new.sh             ← blog-new: neues Page Bundle anlegen
│   ├── publish.sh         ← blog-publish: explizit committen und pushen
│   └── setup.sh           ← blog-spezifische Config abfragen und schreiben
├── jlink/
│   ├── flash.sh
│   └── setup.sh
├── dev-docs/
│   ├── SPEC.md
│   └── TODO.md
├── README.md
└── CLAUDE.md
```

Jeder neue Tool-Bereich bekommt einen eigenen Unterordner mit eigenem `setup.sh`.

---

## 3. Script Library (`scripts.sh`)

Der `scripts` Befehl ist der Einstiegspunkt für das gesamte System.

```
scripts           — listet alle verfügbaren Tools und ihre Commands
scripts --debug   — zeigt zusätzlich Systempfade und Config-Status
```

Debug-Output Beispiel:
```
--- Debug Info ---
Repo:    /Users/andyklenzman/scripts
Config:  ~/.config/scripts/
PATH entries from this repo:
  /Users/andyklenzman/scripts/blog
  /Users/andyklenzman/scripts/jlink
Config files found:
  blog.conf ✓
  jlink.conf ✗ (missing)
```

`lib/` und `dev-docs/` werden aus der Tool-Liste ausgeschlossen.

---

## 4. Shared Utilities (`lib/common.sh`)

Wird von allen Scripts gesourced. Stellt bereit:

- `debug()` — gibt Meldung aus wenn `DEBUG=1`
- `require_config <toolname>` — sourced `~/.config/scripts/<toolname>.conf`, exit wenn nicht vorhanden
- `$SCRIPTS_DIR` — absoluter Pfad zum Repo Root

```bash
source "$(dirname "$0")/../lib/common.sh"
require_config blog
```

---

## 5. PATH-Strategie

`setup.sh` schreibt einmalig diesen Block in `~/.zshrc`:

```bash
# scripts repo — auto-load all tool subdirectories
SCRIPTS_DIR="$HOME/path/to/scripts"
for dir in "$SCRIPTS_DIR"/*/; do
  export PATH="$dir:$PATH"
done
```

Danach ist jedes Script in jedem Unterordner automatisch im PATH — ohne weiteren `~/.zshrc`-Edit wenn ein neues Tool hinzukommt.

---

## 4. XDG Config

Alle Tools teilen einen einzigen XDG-Namespace:

```
~/.config/scripts/
    blog.conf
    jlink.conf
    ...
```

Format pro `.conf`-Datei: einfache `KEY=VALUE`-Zeilen, sourced via `source ~/.config/scripts/blog.conf`.

Jedes Tool-`setup.sh` prüft ob seine `.conf` existiert, fragt interaktiv nach fehlenden Werten, und schreibt die Datei.

---

## 5. Master `setup.sh`

Ablauf:

1. Prüft ob `~/.zshrc` den PATH-Loop bereits enthält — wenn nicht, schreibt ihn rein
2. Ruft `blog/setup.sh` auf
3. Ruft weitere `<tool>/setup.sh` Scripts auf (erweiterbar)
4. Gibt Abschlussmeldung: "Setup abgeschlossen. Starte dein Terminal neu oder führe `source ~/.zshrc` aus."

Idempotent: mehrfaches Ausführen richtet keinen Schaden an.

---

## 6. Blog Tool

### Config (`~/.config/scripts/blog.conf`)

```bash
BLOG_PATH=/Users/andyklenzman/Development/andy.blog
```

`blog/setup.sh` fragt interaktiv nach `BLOG_PATH` wenn nicht gesetzt.

### Commands

#### `blog/new.sh <slug>`

```
Verwendung: blog-new <slug>
```

Ablauf:
1. Liest `BLOG_PATH` aus `~/.config/scripts/blog.conf`
2. Erstellt `$BLOG_PATH/content/items/$(date +%Y-%m-%d)-<slug>/index.md`
3. Schreibt Frontmatter-Template:
   ```yaml
   ---
   date: <ISO8601>
   tags: []
   title: ""
   description: ""
   draft: false
   ---
   ```
4. Gibt den erstellten Pfad aus

#### `blog/publish.sh [commit-message]`

```
Verwendung: blog-publish [optionale commit message]
```

Ablauf:
1. Liest `BLOG_PATH` aus `~/.config/scripts/blog.conf`
2. `cd $BLOG_PATH`
3. `git add -A && git commit -m "${1:-publish items}" && git push`

### Auto-Publish Cron

`blog/setup.sh` richtet optional einen nächtlichen Cron Job ein:

```bash
0 23 * * * source ~/.config/scripts/blog.conf && cd "$BLOG_PATH" && git diff --quiet && git diff --cached --quiet || (git add -A && git commit -m "auto-publish" && git push)
```

---

## 7. Neues Tool hinzufügen — Konvention

1. Ordner `<toolname>/` im Repo Root anlegen
2. `<toolname>/setup.sh` schreiben — liest/schreibt `~/.config/scripts/<toolname>.conf`
3. Tool-Scripts in `<toolname>/` ablegen
4. `<toolname>/setup.sh` in Master-`setup.sh` eintragen
5. README aktualisieren

Keine weiteren Schritte. Der PATH-Loop erkennt den neuen Ordner automatisch.

---

## 8. README-Inhalt

### Abschnitte

- **Was ist das?** — Kurzbeschreibung: portables Sammlung von persönlichen macOS-Automations
- **Setup auf einem neuen System** — drei Schritte:
  1. Repo klonen
  2. `chmod +x setup.sh && ./setup.sh` ausführen
  3. Terminal neu starten
- **Tools** — Tabelle: Tool | Beschreibung | Commands
- **Neues Tool hinzufügen** — Verweis auf Konvention aus Abschnitt 7 dieses SPEC

---

## 9. CLAUDE.md-Inhalt (Projektebene)

Muss dokumentieren:

- Repo-Zweck und Wachstumsstrategie (ein Ordner pro Tool)
- XDG-Config-Konvention (`~/.config/scripts/<tool>.conf`)
- PATH-Strategie (Loop in `~/.zshrc`, geschrieben von `setup.sh`)
- Wie ein neues Tool korrekt hinzugefügt wird (Checkliste aus Abschnitt 7)
- Was entfernt wurde: `variablestore.sh` → ersetzt durch XDG-Config

---

## 10. Was nicht gebaut wird

- Kein Python CLI
- Kein zentrales Config-Management-Framework
- Kein Custom Hugo Plugin
- Kein eigener Server oder Backend
- Keine Mocks oder Test-Modi

---

## 11. Mobile Workflow (iOS)

Separat von diesem Repo. Wird mit Working Copy + iOS Shortcuts abgedeckt. Kein Script-Anteil in diesem Repo.

| Schritt | Was |
|---------|-----|
| 1 | Working Copy installieren, `andy.blog` verbinden |
| 2 | iOS Shortcut: Slug eingeben → Frontmatter generieren → in Bundle-Ordner legen → Push |
| 3 | Draft-Auswahl im Shortcut: `draft: true` oder `draft: false` |
