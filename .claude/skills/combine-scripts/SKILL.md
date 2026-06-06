---
name: combine-scripts
description: Combine individual .rb files back into Scripts.rxdata
argument-hint: "[no arguments]"
user-invocable: true
allowed-tools: Bash, Read
model: sonnet
---

# Combine Scripts

Combine individual .rb files back into Scripts.rxdata.

## Workflow

### 1. Verify Environment
- Check that `la-base-de-sky/LA BASE DE SKY/scripts_combine.rb` exists
- Check that `la-base-de-sky/LA BASE DE SKY/Data/Scripts/` exists

### 2. Backup Current Scripts
```bash
cd "la-base-de-sky/LA BASE DE SKY"
cp Data/Scripts.rxdata Data/ScriptsBackup.rxdata
```

### 3. Combine Scripts
```bash
ruby scripts_combine.rb
```

### 4. Verify Combination
- Check that `Data/Scripts.rxdata` was updated
- Compare file size with backup

### 5. Output Summary
```
Scripts Combination Complete
============================
Combined: [N] scripts into Data/Scripts.rxdata
Backup: Data/ScriptsBackup.rxdata
Next: Test the game to verify no syntax errors
```

## Notes
- Always creates a backup before combining
- Script ordering is determined by filename prefixes
- Test the game after combining to catch syntax errors
- If errors occur, restore from ScriptsBackup.rxdata

## Reference
- `wiki-la-base-de-sky/wiki_markdown/08-Herramientas/scripts-utiles.md`
- `wiki-la-base-de-sky/wiki_markdown/08-Herramientas/secciones-scripts.md`
