---
name: validate-pbs
description: Validate PBS file syntax and cross-references
argument-hint: "[file] | all"
user-invocable: true
allowed-tools: Read, Glob, Grep
model: sonnet
---

# Validate PBS

Validate PBS file syntax and cross-references.

## Workflow

### 1. Parse Arguments
- If `[file]` provided: validate that specific PBS file
- If `all`: validate all PBS files in `PBS/`

### 2. Validation Checks

For each PBS file:
- Check syntax (sections start with `[ID]`, fields are `key = value`)
- Check for duplicate IDs
- Check cross-references (e.g., `Evolves: CHARMANDER` must reference existing species)
- Check required fields (see `.claude/rules/pbs-files.md`)
- Check numeric fields are valid
- Check list format (comma-separated, no spaces)

### 3. Report Results
```
PBS Validation Report
=====================
File: pokemon.txt
  ✓ Syntax valid
  ✓ 151 species defined
  ✗ Duplicate ID: [MISSINGNO] (line 1023)
  ✗ Invalid reference: Evolves to [FAKE_MON] (line 45)

File: moves.txt
  ✓ Syntax valid
  ✓ 898 moves defined
  ✓ All cross-references valid

Summary: 1 file with errors, 1 file valid
```

### 4. Suggest Fixes
For each error, suggest the fix:
- Duplicate ID: "Remove or rename duplicate section"
- Invalid reference: "Check spelling or add missing entry first"

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `Duplicate ID` | Two sections with same `[ID]` | Rename or remove duplicate |
| `Unknown species` | Evolution references non-existent Pokémon | Check spelling, add species first |
| `Unknown move` | Trainer knows non-existent move | Check spelling, add move first |
| `Invalid type` | Wrong type name | Use uppercase: FIRE, not Fire or fire |
| `Missing field` | Required field not present | Add required field |
| `Bad list format` | Spaces in comma-separated list | Remove spaces: `A,B` not `A, B` |

## Reference
- `.claude/rules/pbs-files.md` — PBS syntax rules
- `wiki-la-base-de-sky/wiki_markdown/08-Herramientas/pbs.md` — PBS format reference
