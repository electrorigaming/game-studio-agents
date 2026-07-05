---
trigger: path_pattern
path_pattern: "PBS/*.txt"
---

# PBS Files Rules

## Sintaxis PBS

- ALL PBS files MUST follow the exact syntax: sections start with `[ID]`, fields are `key = value`
- IDs MUST be unique within each file (no duplicate `[BULBASAUR]` in `pokemon.txt`)
- Cross-references MUST be valid (e.g., `Evolution = CHARMANDER,Level,16` must reference existing species)
- Lists MUST use comma-separated values without spaces after commas: `Types = GRASS,POISON`
- Numeric fields MUST use integers or floats as appropriate (no quotes)
- Text fields with spaces MUST NOT be quoted (e.g., `Name = Bulbasaur`, not `Name = "Bulbasaur"`)
- Comments MUST start with `#` and be on their own line
- Blank lines are allowed for readability but not required

## Required Sections by File

Field names verified against real entries in `PBS/pokemon.txt` and `PBS/moves.txt` (e.g.
`[BULBASAUR]`, `[TACKLE]`) — see `scripts/validate_pbs.rb` for the enforced required subset.

### pokemon.txt
- `Name`, `Types`, `BaseStats` (HP,ATK,DEF,SPD,SA,SD), `GenderRatio`, `GrowthRate`, `BaseExp`,
  `EVs` (stat,points — not a 6-value yield list), `CatchRate`, `Happiness`, `Abilities`,
  `HiddenAbilities`, `Moves` (level,MOVE pairs), `TutorMoves`, `EggMoves`, `EggGroups`,
  `HatchSteps`, `Height`, `Weight`, `Color`, `Shape`, `Habitat`, `Category`, `Pokedex`,
  `Generation`, `Evolution` (singular — `Evolutions` plural is also accepted by the compiler
  as an alias, but `Evolution` is the form used throughout this base's real PBS data),
  `WildItemCommon`/`WildItemUncommon`/`WildItemRare` (all optional, omit if not applicable)

### moves.txt
- `Name`, `Type`, `Category`, `Power` (omit for most Status moves), `Accuracy`, `TotalPP`
  (not `PP`), `Target`, `Priority` (optional, omit if 0), `FunctionCode` (not `Effect`),
  `EffectChance` (optional, only for moves with a secondary-effect chance), `Flags`, `Description`

### trainers.txt
Structurally different from the files above: the section ID is `[TrainerType,Name]` (comma
inside the brackets), and `Pokemon = [species],[level]` lines repeat once per party member,
each followed by **indented** sub-fields that apply only to that Pokémon:
```
[TrainerType,Name]
Items = [item1],[item2]
LoseText = [text]
Pokemon = [SPECIES],[level]
    Moves = [MOVE1],[MOVE2],[MOVE3],[MOVE4]
    AbilityIndex = [0 or 1]
    Item = [item]
    Gender = [male/female]
    IV = [HP],[ATK],[DEF],[SPD],[SA],[SD]
```
Only `Pokemon =` is required per party member; every indented sub-field is optional.

## Examples

**Correct** (real entry from `PBS/pokemon.txt`):
```
[BULBASAUR]
Name = Bulbasaur
Types = GRASS,POISON
BaseStats = 45,49,49,45,65,65
EVs = SPECIAL_ATTACK,1
Abilities = OVERGROW
Height = 0.7
Weight = 6.9
```

**Incorrect** (violations):
```
[BULBASAUR]
Name: "Bulbasaur"          # VIOLATION: must use `=`, and no quotes allowed
Types = GRASS, POISON      # VIOLATION: no space after comma
BaseStats = 45 49 49 65 65 65  # VIOLATION: must use commas
```

## Reference Documentation

**MANDATORY**: Before modifying PBS data, consult:
- `../wiki-la-base-de-sky/wiki_markdown/08-Herramientas/pbs.md` — PBS format reference
- `../wiki-la-base-de-sky/wiki_markdown/02-Pokemon/01-Pokemon/definir-especie.md` — Species format
- `../wiki-la-base-de-sky/wiki_markdown/02-Pokemon/02-Movimientos/definir-movimiento.md` — Move format
- `../wiki-la-base-de-sky/wiki_markdown/03-Combate/02-Personas/definir-entrenador.md` — Trainer format
