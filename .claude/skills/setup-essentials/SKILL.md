---
name: setup-essentials
description: Configure the project for La Base de Sky (Pokémon Essentials)
argument-hint: "[no arguments]"
user-invocable: true
allowed-tools: Read, Write, Edit, Bash
model: sonnet
---

# Setup Essentials

Configure the project for La Base de Sky (Pokémon Essentials).

## Workflow

### 1. Verify La Base de Sky Installation
- Check that `../la-base-de-sky/LA BASE DE SKY/Game.exe` exists
- Check that `../la-base-de-sky/LA BASE DE SKY/PBS/` exists
- Check that `../la-base-de-sky/LA BASE DE SKY/scripts_extract.rb` exists

### 2. Update CLAUDE.md Technology Stack
Ask: "May I update CLAUDE.md with La Base de Sky configuration?"

Update:
```markdown
## Technology Stack

- **Engine**: RPG Maker XP + Pokémon Essentials v21.1/v22
- **Language**: Ruby (RGSS - RPG Game Scripting System)
- **Version Control**: Git
- **Build System**: RPG Maker XP (Game.exe) + scripts_combine.rb
- **Asset Pipeline**: RPG Maker XP (Graphics/, Audio/) + PBS files
- **Reference Documentation**: ../wiki-la-base-de-sky/wiki_markdown/
```

### 3. Update Technical Preferences
Update `.claude/docs/technical-preferences.md` (already populated with the verified stack —
mkxp-z, Ruby 3.1.3, naming conventions, specialist routing). Only update it here if the
project's actual install differs from what's already recorded (different Ruby/Essentials
version, custom folder layout, etc.) — verify against the real install before overwriting,
per the anti-hallucination discipline in the Fase 1 diagnostic (do not assume PascalCase
script names or a `BGS/` audio folder without checking; this base uses `NNN_Description.rb`
and has no `BGS/` subfolder).

## File Extension Routing

| File Extension / Type | Specialist to Spawn |
|-----------------------|---------------------|
| PBS data files (PBS/*.txt) | pbs-compiler-specialist |
| Ruby scripts (**/*.rb) | ruby-rgss-specialist |
| Event script calls (proposed for RPG Maker's event editor) | level-designer |
| Map data (Data/Map*.rxdata) | level-designer |
| Graphics/Audio assets | essentials-specialist |
| Plugin code (Plugins/**/*.rb) | ruby-rgss-specialist |
| General architecture | essentials-specialist |
```

### 4. Test Script Extraction
Ask: "Would you like me to test script extraction now?"
- If yes: Run `/extract-scripts`
- Verify extraction successful

### 4b. Offer Maker Studio (optional second editor)
- Check whether `../maker-studio/` exists (the sibling clone of the Maker Studio editor repo).
- If it exists, remind the user that two editors are available for maps/events/tilesets:
  RPG Maker XP and Maker Studio. Point to `.claude/docs/maker-studio.md` for the install steps
  (editor app + `MakerStudio` plugin) and the coexistence rules.
- The plugin is committed only on `game/*` branches of `la-base-de-sky` — never on `main`.
  If no `game/*` branch exists yet, installation stays documented-only until `/brainstorm`
  creates one.

### 5. Output Summary
```
Essentials Setup Complete
=========================
Engine: RPG Maker XP + Pokémon Essentials v21.1/v22
Editors: RPG Maker XP + Maker Studio ([available/not cloned] — see .claude/docs/maker-studio.md)
Language: Ruby (RGSS)
PBS Files: [N] files in PBS/
Scripts: [Extracted/Not extracted]
Reference: ../wiki-la-base-de-sky/wiki_markdown/

Next Steps:
1. Run /brainstorm to design your Pokémon game
2. Run /extract-scripts to begin editing scripts
3. Consult wiki-la-base-de-sky for implementation guides
```

## Reference
- `../wiki-la-base-de-sky/wiki_markdown/08-Herramientas/` — Tools and configuration
- `../wiki-la-base-de-sky/wiki_markdown/01-Inicio/01-Inicio/instalacion.md` — Installation guide
- `.claude/docs/maker-studio.md` — Maker Studio (second editor): install and coexistence rules
