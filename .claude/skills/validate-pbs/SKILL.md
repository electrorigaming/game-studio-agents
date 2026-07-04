---
name: validate-pbs
description: Validate PBS file syntax and cross-references
argument-hint: "[file] | all"
user-invocable: true
allowed-tools: Bash, Read
model: sonnet
---

# Validate PBS

Validate PBS file syntax and cross-references by running the deterministic
validator at `scripts/validate_pbs.rb`. This is not LLM-judged: the script
parses every file the same way every time, so results are reproducible.

## Workflow

### 1. Run the Validator
```bash
ruby scripts/validate_pbs.rb all        # validate every *.txt in PBS/
ruby scripts/validate_pbs.rb pokemon.txt  # validate a single file
```

### 2. Relay the Report
The script prints a report and exits 0 (all checked files clean) or 1 (errors found).
Show the full output to the user as-is — do not paraphrase or summarize away specific
errors, since each line names the exact file, line number, and section.

Fully schema-validated files: `pokemon.txt`, `moves.txt`, `trainers.txt`, `abilities.txt`,
`items.txt` (the ones with a documented schema in `.claude/rules/pbs-files.md`). Other
`PBS/*.txt` files use ad-hoc sub-formats (semicolon-delimited rows, repeated non-unique
tags, bare name lists) and are reported as "skipped (non-standard format)" rather than
false-flagged.

### 3. Suggest Fixes
For each error reported, suggest the fix:
- `Duplicate ID`: rename or remove the duplicate section
- `references unknown species/move/ability/item`: check spelling, or add the missing entry first
- `Missing required field`: add the field (see `.claude/rules/pbs-files.md`)
- `Bad list format`: remove the space after the comma: `A,B` not `A, B`
- `Line is not a valid key = value pair`: fix the syntax (no colons, no quotes)

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `Duplicate ID` | Two sections with same `[ID]` | Rename or remove duplicate |
| `Evolution references unknown species` | Evolution target doesn't exist in pokemon.txt | Check spelling, add species first |
| `Moves/TutorMoves/EggMoves references unknown move` | Move name doesn't exist in moves.txt | Check spelling, add move first |
| `Abilities/HiddenAbilities references unknown ability` | Ability doesn't exist in abilities.txt | Check spelling, add ability first |
| `Missing required field` | Required field not present | Add required field |
| `Bad list format` | Space after comma in a list field | Remove spaces: `A,B` not `A, B` |

## Reference
- `scripts/validate_pbs.rb` — the deterministic validator this skill runs
- `.claude/rules/pbs-files.md` — PBS syntax rules
- `../wiki-la-base-de-sky/wiki_markdown/08-Herramientas/pbs.md` — PBS format reference
