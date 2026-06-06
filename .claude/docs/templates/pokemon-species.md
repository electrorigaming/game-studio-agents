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
```
[[ID]]
Name = [name]
Types = [type1],[type2]
BaseStats = [HP],[ATK],[DEF],[SPD],[SA],[SD]
EVYield = [HP],[ATK],[DEF],[SPD],[SA],[SD]
Abilities = [ability1],[ability2]
GenderRate = [rate]
GrowthRate = [rate]
BaseEXP = [exp]
Happiness = [value]
StepsToHatch = [steps]
Color = [color]
Shape = [shape]
Habitat = [habitat]
Kind = [classification]
Pokedex = [description]
Metrics = [height],[weight],0,0
WildItemCommon = [item]
WildItemUncommon = [item]
WildItemRare = [item]
```

## Implementation Notes
- Reference: `wiki-la-base-de-sky/wiki_markdown/02-Pokemon/01-Pokemon/definir-especie.md`
- Ensure all cross-references (abilities, evolutions, items) exist in their respective PBS files
- Test in-game to verify sprites and stats display correctly
