---
name: extract-scripts
description: Extract Scripts.rxdata into individual .rb files for editing
argument-hint: "[no arguments]"
user-invocable: true
allowed-tools: Bash, Read
model: sonnet
---

# Extract Scripts

Extract Scripts.rxdata into individual .rb files for editing.

## Workflow

### 1. Verify Environment
- Check that `../la-base-de-sky/LA BASE DE SKY/scripts_extract.rb` exists
- Check that `../la-base-de-sky/LA BASE DE SKY/Data/Scripts.rxdata` exists

### 2. Extract Scripts
Run the extraction script:
```bash
cd "../la-base-de-sky/LA BASE DE SKY"
ruby scripts_extract.rb
```

### 3. Verify Extraction
- Check that `Data/Scripts/` directory was created
- Count extracted `.rb` files
- List first 10 files for verification

### 4. Output Summary
```
Scripts Extraction Complete
===========================
Extracted: [N] scripts to Data/Scripts/
Next: Edit individual .rb files, then run /combine-scripts
```

## Notes
- Always backup Scripts.rxdata before extraction
- Extracted files can be edited individually
- Use /combine-scripts to regenerate Scripts.rxdata after editing
- Script ordering is preserved in filenames (e.g., 001_ScriptName.rb)

## Reference
- `../wiki-la-base-de-sky/wiki_markdown/08-Herramientas/scripts-utiles.md`
