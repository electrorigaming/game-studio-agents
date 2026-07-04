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
- Check that `../la-base-de-sky/LA BASE DE SKY/scripts_combine.rb` exists
- Check that `../la-base-de-sky/LA BASE DE SKY/Data/Scripts/` exists

### 2. Backup Extracted Scripts
`scripts_combine.rb` **deletes** `Data/Scripts/` after it finishes (verified in the Fase 1 diagnostic —
it calls `FileUtils.rm_rf` on the folder). At this point `Data/Scripts.rxdata` is just the small loader
stub written by the last extraction, NOT the real script data — do NOT copy it over `ScriptsBackup.rxdata`,
that would overwrite the real backup with the stub. Instead, back up the extracted folder itself:
```bash
cd "../la-base-de-sky/LA BASE DE SKY"
cp -r Data/Scripts "Data/Scripts_backup_$(date +%Y%m%d_%H%M%S)"
```

### 3. Combine Scripts
```bash
ruby scripts_combine.rb
```

### 4. Verify Combination
- Check that `Data/Scripts.rxdata` was updated (should grow from ~576 bytes to the real combined size)
- Check that `Data/Scripts/` was removed by the script (expected — that's how `scripts_combine.rb` works)

### 5. Output Summary
```
Scripts Combination Complete
============================
Combined: [N] scripts into Data/Scripts.rxdata
Folder backup: Data/Scripts_backup_[timestamp]/
Next: Test the game to verify no syntax errors
```

## Notes
- Always back up `Data/Scripts/` before combining — the script deletes that folder on success
- Script ordering is determined by filename prefixes
- Test the game after combining to catch syntax errors
- If errors occur, restore the folder backup and re-run `/combine-scripts`, or restore
  `Data/ScriptsBackup.rxdata` (the original pre-extraction combined file) if starting over

## Reference
- `../wiki-la-base-de-sky/wiki_markdown/08-Herramientas/scripts-utiles.md`
- `../wiki-la-base-de-sky/wiki_markdown/08-Herramientas/secciones-scripts.md`
