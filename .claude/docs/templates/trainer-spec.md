# Trainer: [Name]

## Basic Info
- **Trainer Type**: [type ID, MUST already exist in `PBS/trainer_types.txt` — never invent one].
  Generic trainer classes share one existing type across many named individuals (e.g. the
  real `[BUGCATCHER]` type is reused for every Bug Catcher — do NOT invent
  `BUGCATCHER_<Name>` per instance, that type won't exist and the PBS compiler will reject
  it). Unique named trainers (gym leaders, rivals) genuinely do get their own dedicated
  type, e.g. `LEADER_Brock` — but that's because `trainer_types.txt` defines that exact ID,
  not a general naming convention. Grep `PBS/trainer_types.txt` for the class before writing
  the entry.
- **Name**: [in-game display name]
- **Role**: [e.g., Gym Leader, Rival, Generic trainer]

## Battle Text
- **Intro**: [what the trainer says when the battle starts — set on the map event, not in PBS]
- **Win Text** (trainer wins): [text]
- **Lose Text** (trainer loses): [text]

## Party
List each Pokémon with level, moves, and any non-default properties (item, ability, IVs, shiny, ball).

| # | Species | Level | Moves | Item | Ability | Notes |
|---|---------|-------|-------|------|---------|-------|
| 1 | [SPECIES] | [level] | [move1, move2, ...] | [item or —] | [ability slot] | [shiny, ball, gender, form...] |

## Held Items (usable in battle)
- [item1], [item2] — items in the trainer's bag, used automatically (e.g. Full Restore)

## PBS Entry
Field names, indentation, and structure verified against real entries in `PBS/trainers.txt`
(e.g. `[LEADER_Brock,Brock]`). The section ID is `TrainerType,Name` — both must be exact:
the trainer type must exist in `PBS/trainer_types.txt`. `Pokemon = ` lines repeat once per
party member; the indented lines directly under each `Pokemon =` line describe that specific
Pokémon only — indentation matters here, unlike in other PBS files.
```
[TrainerType,Name]
Items = [item1],[item2]
LoseText = [text]
Pokemon = [SPECIES],[level]
    Name = [nickname — omit to use the species name]
    Moves = [MOVE1],[MOVE2],[MOVE3],[MOVE4]
    AbilityIndex = [0 or 1 — which of the species' two Abilities slots]
    Item = [held item — omit for none]
    Gender = [male/female — omit for random]
    Form = [form number — omit for form 0]
    IV = [HP],[ATK],[DEF],[SPD],[SA],[SD]
    Shiny = [true — omit for not shiny]
    Ball = [POKEBALL variant — omit for default]
Pokemon = [SPECIES2],[level2]
    Moves = [MOVE1],[MOVE2]
```
Every field except `Pokemon =` under a party member is optional — omit any that don't apply
rather than filling with placeholder/default values.

## Implementation Notes
- Reference: `../wiki-la-base-de-sky/wiki_markdown/03-Combate/02-Personas/definir-entrenador.md`
- Species in `Pokemon =`, moves in `Moves =`, and items in `Item =` must all exist in their
  respective PBS files (`pokemon.txt`, `moves.txt`, `items.txt`) — run `/validate-pbs trainers.txt`
  after adding
- The trainer's map event (sprite, position, sight range, battle trigger) is configured
  separately in RPG Maker's event editor, not in this PBS entry
