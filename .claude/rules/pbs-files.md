---
trigger: path_pattern
path_pattern: "PBS/*.txt"
---

# PBS Files Rules

## Sintaxis PBS

- ALL PBS files MUST follow the exact syntax: sections start with `[ID]`, fields are `key = value`
- IDs MUST be unique within each file (no duplicate `[BULBASAUR]` in `pokemon.txt`)
- Cross-references MUST be valid (e.g., `Evolves: CHARMANDER,Level,16` must reference existing species)
- Lists MUST use comma-separated values without spaces after commas: `Types: GRASS,POISON`
- Numeric fields MUST use integers or floats as appropriate (no quotes)
- Text fields with spaces MUST NOT be quoted (e.g., `Name: Bulbasaur`, not `Name: "Bulbasaur"`)
- Comments MUST start with `#` and be on their own line
- Blank lines are allowed for readability but not required

## Required Sections by File

### pokemon.txt
- `Name`, `Types`, `BaseStats` (HP,ATK,DEF,SPD,SA,SD), `EVYield`, `GenderRate`, `HatchSteps`, `BaseExp`, `EffortPoints`, `WildItemCommon`, `WildItemUncommon`, `WildItemRare`, `Abilities`, `Height`, `Weight`, `Color`, `Shape`, `Habitat`, `Kind`, `Pokedex`, `Metrics`

### moves.txt
- `Name`, `Type`, `Category`, `Power`, `Accuracy`, `PP`, `Effect`, `EffectChance`, `Target`, `Priority`, `Flags`, `Description`

### trainers.txt
- `Name`, `Items`, `Pokemon: [species],[level],[move1],[move2],[move3],[move4]`

## Examples

**Correct** (PBS format):
```
[BULBASAUR]
Name = Bulbasaur
Types = GRASS,POISON
BaseStats = 45,49,49,65,65,65
EVYield = 0,0,0,0,1,0
Abilities = OVERGROW,CHLOROPHYLL
Height = 0.7
Weight = 6.9
```

**Incorrect** (violations):
```
[BULBASAUR]
Name: "Bulbasaur"          # VIOLATION: no quotes allowed
Types = GRASS, POISON      # VIOLATION: no space after comma
BaseStats = 45 49 49 65 65 65  # VIOLATION: must use commas
```

## Reference Documentation

**MANDATORY**: Before modifying PBS data, consult:
- `../wiki-la-base-de-sky/wiki_markdown/08-Herramientas/pbs.md` — PBS format reference
- `../wiki-la-base-de-sky/wiki_markdown/02-Pokemon/01-Pokemon/definir-especie.md` — Species format
- `../wiki-la-base-de-sky/wiki_markdown/02-Pokemon/02-Movimientos/definir-movimiento.md` — Move format
- `../wiki-la-base-de-sky/wiki_markdown/03-Combate/02-Personas/definir-entrenador.md` — Trainer format
