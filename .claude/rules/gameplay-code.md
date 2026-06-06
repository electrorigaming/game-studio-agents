---
trigger: path_pattern
path_pattern: "Plugins/**/Battle_*.rb"
---

# Gameplay Code Rules

## Data-Driven Design

- ALL gameplay values MUST come from PBS files, NEVER hardcoded
- Use `:SPECIES`, `:MOVE`, `:ITEM` symbols, never numeric IDs
- Use Essentials event hooks (`Events.onBattleStart`, etc.) for cross-system communication
- Every gameplay system must implement a clear interface
- State machines must have explicit transition tables with documented states
- Document which design doc each feature implements in code comments

## RGSS-Specific Rules

- Use `alias` for method overriding, NEVER monkey-patch core methods directly
- Always call `dispose` on Sprite, Viewport, Window objects when done
- Use `pbMessage(text)` for dialog, NOT `print` or `puts`
- Use `pbRNG.rand(n)` for random numbers in battle (deterministic for replays)

## Examples

**Correct** (data-driven from PBS):

```ruby
# Get move power from PBS data
move = pbGetMove(:THUNDERBOLT)
power = move.power  # 90, defined in PBS/moves.txt

# Get species base stats from PBS
species_data = pbGetSpeciesData(:PIKACHU)
base_speed = species_data.base_stats[:speed]  # 90, defined in PBS/pokemon.txt
```

**Incorrect** (hardcoded):

```ruby
# VIOLATION: hardcoded gameplay value
power = 90

# VIOLATION: hardcoded species ID
if species_id == 25  # Should use :PIKACHU symbol
  # ...
end
```

## Reference Documentation

**MANDATORY**: Before implementing gameplay code, consult:
- `wiki-la-base-de-sky/wiki_markdown/03-Combate/` — Battle system
- `wiki-la-base-de-sky/wiki_markdown/02-Pokemon/` — Pokémon data
- `wiki-la-base-de-sky/wiki_markdown/08-Herramientas/pbs.md` — PBS format
