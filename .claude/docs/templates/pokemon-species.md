# Pokémon Species: [Name]

## Basic Info
- **National Dex**: #[number]
- **Name**: [English name]
- **Name (Spanish)**: [Spanish name]
- **Type(s)**: [type1], [type2]
- **Classification**: [e.g., "Seed Pokémon"]

## Stats
| Stat | Base |
|------|------|
| HP | [value] |
| Attack | [value] |
| Defense | [value] |
| Sp. Atk | [value] |
| Sp. Def | [value] |
| Speed | [value] |
| **Total** | [sum] |

## Abilities
- **Ability 1**: [name] — [description]
- **Ability 2** (Hidden): [name] — [description]

## Evolution
- **Evolves from**: [species] (method, level/item)
- **Evolves into**: [species] (method, level/item)

## Breeding
- **Egg Groups**: [group1], [group2]
- **Gender Ratio**: [ratio]
- **Hatch Steps**: [steps]

## Physical
- **Height**: [meters] m
- **Weight**: [kg] kg
- **Color**: [color]
- **Shape**: [shape]

## PBS Entry
Field names and order verified against real entries in `PBS/pokemon.txt` (e.g. `[BULBASAUR]`):
```
[ID]
Name = [name]
Types = [type1],[type2]
BaseStats = [HP],[ATK],[DEF],[SPD],[SA],[SD]
GenderRatio = [rate, e.g. FemaleOneEighth]
GrowthRate = [rate, e.g. Parabolic]
BaseExp = [exp]
EVs = [stat],[points]
CatchRate = [value]
Happiness = [value]
Abilities = [ability1],[ability2]
HiddenAbilities = [ability]
Moves = [level1],[MOVE1],[level2],[MOVE2],...
TutorMoves = [MOVE1],[MOVE2],...
EggMoves = [MOVE1],[MOVE2],...
EggGroups = [group1],[group2]
HatchSteps = [steps]
Height = [meters]
Weight = [kg]
Color = [color]
Shape = [shape]
Habitat = [habitat]
Category = [classification]
Pokedex = [description]
Generation = [number]
Evolution = [SPECIES],[Method],[Param]
WildItemCommon = [item]
WildItemUncommon = [item]
WildItemRare = [item]
```
`WildItemCommon`/`WildItemUncommon`/`WildItemRare` are optional — omit any the species doesn't have.
Physical measurements beyond Height/Weight (footprint metrics, etc.) live in the separate
`PBS/pokemon_metrics.txt` file, not in this entry.

## Implementation Notes
- Reference: `../wiki-la-base-de-sky/wiki_markdown/02-Pokemon/01-Pokemon/definir-especie.md`
- Ensure all cross-references (abilities, evolutions, items) exist in their respective PBS files
- Test in-game to verify sprites and stats display correctly
