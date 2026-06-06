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
- Check that `la-base-de-sky/LA BASE DE SKY/Game.exe` exists
- Check that `la-base-de-sky/LA BASE DE SKY/PBS/` exists
- Check that `la-base-de-sky/LA BASE DE SKY/scripts_extract.rb` exists

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
- **Reference Documentation**: wiki-la-base-de-sky/wiki_markdown/
```

### 3. Update Technical Preferences
Create/update `.claude/docs/technical-preferences.md`:
```markdown
## Engine & Language
- **Engine**: RPG Maker XP + Pokémon Essentials v21.1/v22
- **Language**: Ruby (RGSS)
- **Script Management**: scripts_extract.rb / scripts_combine.rb

## Naming Conventions
- **PBS Files**: lowercase_snake.txt (pokemon.txt, moves.txt)
- **Ruby Scripts**: PascalCase.rb (PokeBattle_Battle.rb)
- **Graphics**: Subcarpetas por tipo (Characters/, Battlers/, Icons/)
- **Audio**: BGM/, BGS/, ME/, SE/

## Essentials Specialists
- **Primary**: essentials-specialist
- **Ruby/RGSS**: ruby-rgss-specialist
- **PBS Data**: pbs-compiler-specialist
- **Level Design**: level-designer (adaptado para RPG Maker)

## File Extension Routing

| File Extension / Type | Specialist to Spawn |
|-----------------------|---------------------|
| PBS data files (PBS/*.txt) | pbs-compiler-specialist |
| Ruby scripts (**/*.rb) | ruby-rgss-specialist |
| Event data (Data/Events/*.json) | level-designer |
| Map data (Data/Map*.rxdata) | level-designer |
| Graphics/Audio assets | essentials-specialist |
| Plugin code (Plugins/**/*.rb) | ruby-rgss-specialist |
| General architecture | essentials-specialist |
```

### 4. Test Script Extraction
Ask: "Would you like me to test script extraction now?"
- If yes: Run `/extract-scripts`
- Verify extraction successful

### 5. Output Summary
```
Essentials Setup Complete
=========================
Engine: RPG Maker XP + Pokémon Essentials v21.1/v22
Language: Ruby (RGSS)
PBS Files: [N] files in PBS/
Scripts: [Extracted/Not extracted]
Reference: wiki-la-base-de-sky/wiki_markdown/

Next Steps:
1. Run /brainstorm to design your Pokémon game
2. Run /extract-scripts to begin editing scripts
3. Consult wiki-la-base-de-sky for implementation guides
```

## Reference
- `wiki-la-base-de-sky/wiki_markdown/08-Herramientas/` — Tools and configuration
- `wiki-la-base-de-sky/wiki_markdown/01-Inicio/01-Inicio/instalacion.md` — Installation guide
