---
name: setup-engine
description: "Configure the project's game engine. For La Base de Sky, redirects to /setup-essentials. Supports refresh and upgrade for Essentials versions."
argument-hint: "refresh | upgrade [old-version] [new-version] | no args for /setup-essentials"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, WebSearch, WebFetch, Task, AskUserQuestion
model: sonnet
---

When this skill is invoked:

## 1. Parse Arguments

Three modes:

- **No args**: `/setup-engine` — redirects to `/setup-essentials` for La Base de Sky
- **Refresh**: `/setup-engine refresh` — update reference docs (see Section 3)
- **Upgrade**: `/setup-engine upgrade [old-version] [new-version]` — migrate to a new Essentials version (see Section 4)

---

## 2. Default Mode (No Arguments)

**For La Base de Sky projects**, the engine is already defined:
- **Engine**: RPG Maker XP + Pokémon Essentials v21.1/v22
- **Language**: Ruby (RGSS)
- **Base**: La Base de Sky (Spanish)

Redirect to `/setup-essentials` for full configuration:
> "This project uses La Base de Sky (Pokémon Essentials v21.1/v22 on RPG Maker XP). Running `/setup-essentials` to configure the project..."

Then invoke `/setup-essentials`.

---

## 3. Refresh Subcommand

If invoked as `/setup-engine refresh`:

### 3.1 Check for Updates
- Search web for latest La Base de Sky version
- Search web for latest Pokémon Essentials version
- Compare with current pinned version in `CLAUDE.md`

### 3.2 Update Reference Docs
- Update `wiki-la-base-de-sky` if new wiki content available:
  ```bash
  cd wiki-la-base-de-sky
  python updater_wiki/descargar_wiki.py
  ```
- Commit and push wiki updates

### 3.3 Report
```
Engine Reference Refresh
========================
La Base de Sky: [current version] → [latest version if available]
Pokémon Essentials: [current version] → [latest version if available]
Wiki: [updated/not updated]

Next: Review changelog at wiki-la-base-de-sky/wiki_markdown/09-Info/changelog.md
```

---

## 4. Upgrade Subcommand

If invoked as `/setup-engine upgrade [old-version] [new-version]`:

### 4.1 Read Current Version State
- Read `CLAUDE.md` to confirm current Essentials version
- Check `wiki-la-base-de-sky/wiki_markdown/09-Info/changelog.md` for migration notes

### 4.2 Fetch Migration Guide
- Search web for migration guide between versions
- Extract: renamed APIs, removed APIs, changed PBS format, breaking changes

### 4.3 Pre-Upgrade Audit
- Scan `Plugins/` for custom plugins that may need updates
- Scan `PBS/` for deprecated PBS fields
- List files requiring changes

### 4.4 Confirm Before Updating
Ask the user before making any changes:
> "Pre-upgrade audit complete. Found [N] files potentially affected. Proceed with upgrade notes?"

### 4.5 Update CLAUDE.md
After confirmation:
- Update `CLAUDE.md` with new version
- Add migration notes section
- Update `wiki-la-base-de-sky` if needed

### 4.6 Post-Upgrade Reminder
```
Upgrade Notes: [old-version] → [new-version]
================================================

Next steps:
1. Review migration notes in CLAUDE.md
2. Update custom plugins if needed
3. Run /validate-pbs to check PBS compatibility
4. Test game to verify no breaking changes
5. Run /setup-engine refresh to verify docs are current
```

---

## Reference
- `wiki-la-base-de-sky/wiki_markdown/09-Info/changelog.md` — Version changelog
- `wiki-la-base-de-sky/wiki_markdown/01-Inicio/` — Installation and setup
