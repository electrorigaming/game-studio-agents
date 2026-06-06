---
trigger: path_pattern
path_pattern: "Data/Events/*.json"
---

# RPG Maker Events Rules

## Event Page Organization

- Event pages MUST be ordered by condition priority (highest priority first)
- Switch conditions MUST use meaningful switch IDs (document in `Data/Switches.rxdata`)
- Variable conditions MUST use meaningful variable IDs (document in `Data/Variables.rxdata`)
- Script calls in events MUST be tested in isolation before adding to events

## Script Call Conventions

- Use `pbMoveRoute(event_id, move_commands)` for movement, NOT manual coordinate changes
- Use `pbTransferPlayer(map_id, x, y, direction)` for map transfers
- Use `pbFadeOutIn { ... }` for scene transitions (fades automatically)
- Use `pbChoosePosition(pokemon)` for PC storage operations
- Use `pbStorePokemon(pokemon)` to add Pokémon to player's party/PC
- Use `pbDownloadEnabled?` to check if Mystery Gift is available
- Use `pbMessageDownload(text, url)` for downloadable content

## Event Script Calls

**Correct**:
```ruby
# Give player a Pokémon
pbStorePokemon(Pokemon.new(:PIKACHU, 25, $player))

# Set a variable
$game_variables[5] = 10

# Check a switch
if $game_switches[10]
  pbMessage("Switch is ON!")
end

# Transfer player
pbTransferPlayer(5, 10, 15, 2)  # Map 5, X:10, Y:15, facing down
```

**Incorrect**:
```ruby
# VIOLATION: direct coordinate manipulation (use pbTransferPlayer)
$game_player.x = 10
$game_player.y = 15

# VIOLATION: using print instead of pbMessage
print("Hello!")
```

## Global Variables

- `$game_player` — Player character state
- `$game_system` — System settings
- `$game_variables[id]` — Game variables (persistent)
- `$game_switches[id]` — Game switches (persistent, true/false)
- `$game_map` — Current map state
- `$player` — Player trainer data

**IMPORTANT**: NEVER modify globals without understanding side effects.

## Reference Documentation

**MANDATORY**: Before creating events, consult:
- `wiki-la-base-de-sky/wiki_markdown/05-Mundo/eventos.md` — Event system
- `wiki-la-base-de-sky/wiki_markdown/05-Mundo/mapas.md` — Map system
- `wiki-la-base-de-sky/wiki_markdown/08-Herramientas/scripts-utiles.md` — Useful script snippets
