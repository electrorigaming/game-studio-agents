---
trigger: path_pattern
path_pattern: "Plugins/**/*.rb"
---

# Essentials Plugins Rules

## Plugin Structure

La Base de Sky uses a `meta.txt`-based plugin format, NOT the generic Essentials
`PluginManager.register(...)` header-comment convention (verified against
`../wiki-la-base-de-sky/wiki_markdown/08-Herramientas/plugins.md` — this is specific
to this base, do not assume the generic Essentials convention applies here):

- Plugin folder structure: `Plugins/[PluginName]/meta.txt` + any number of `.rb` files/folders
- Plugin MUST have a `meta.txt` with at least `Name`, `Version` (X.Y.Z), and `Essentials`
  (compatible Essentials version, X.Y.Z)
- Plugin MUST NOT modify core Essentials scripts directly (use aliases)
- Plugin MUST be self-contained (no external dependencies beyond Essentials)
- Plugin MUST handle missing assets gracefully (use `pbResolveBitmap` to check)
- Plugin MUST NOT hardcode Pokémon IDs (use `:SPECIES` symbols instead)
- Plugin MUST NOT hardcode move IDs (use `:MOVE` symbols instead)
- Plugin MUST NOT hardcode item IDs (use `:ITEM` symbols instead)
- Plugin MUST use `EventHandlers.add(:hook_name, :id, proc { ... })` hooks when available (see wiki)
- Plugin MUST be compatible with save/load (test save scumming)
- Built-in plugins ship compiled into `Data/Scripts/`, not as `Plugins/` folders — the
  `Plugins/` folder is only for third-party plugins the user installs manually

## meta.txt Fields

`meta.txt` uses the same `Key = Value` syntax as PBS files:

| Field | Required | Meaning |
|-------|----------|---------|
| `Name` | Yes | Plugin name |
| `Version` | Yes | Plugin version, format X.Y.Z |
| `Essentials` | Yes | Compatible Essentials version, format X.Y.Z |
| `Link` | No | Website or repo URL |
| `Credits` | No | Author(s) |
| `Requires` | No | `<PluginName>` or `<PluginName>,<Version>` — dependency, min version if given |
| `Exact` | No | Requires an exact version of another plugin |
| `Optional` | No | `<PluginName>,<Version>` — should load before this plugin, not a hard dependency |
| `Conflicts` | No | `<PluginName>` — errors if loaded together with this plugin |
| `Disabled` | No | Boolean — disables the plugin without removing it |
| `First` | No | Boolean — load before all other plugins |
| `Last` | No | Boolean — load after all other plugins |
| `Priority` | No | Integer — tie-breaker between plugins that are both `First` or both `Last` |

Example `meta.txt`:
```
Name = My Plugin
Version = 1.0.0
Essentials = 21.1
Credits = YourName
```

Installing a plugin: copy its folder into `Plugins/` and restart the game — the improved
Plugin Manager in this base auto-detects added/removed plugin folders.

## Event Hooks

Use Essentials event hooks instead of overriding methods:
```ruby
# Called right before a battle begins
EventHandlers.add(:on_start_battle, :my_plugin_battle_start, proc {
  # Custom logic
})

# Called when a wild Pokémon is generated for an encounter
EventHandlers.add(:on_wild_pokemon_created, :my_plugin_wild_pokemon, proc { |pkmn|
  # Custom logic — pkmn is the Pokemon object
})

# Called when the player enters a new map
EventHandlers.add(:on_enter_map, :my_plugin_map_enter, proc { |old_map_id|
  # Custom logic — old_map_id is 0 if there was no previous map
})
```

## Reference Documentation

**MANDATORY**: Before implementing plugins, consult:
- `../wiki-la-base-de-sky/wiki_markdown/08-Herramientas/plugins.md` — Plugin system
- `../wiki-la-base-de-sky/wiki_markdown/08-Herramientas/scripts-utiles.md` — Useful script snippets
