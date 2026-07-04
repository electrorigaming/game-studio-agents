---
trigger: path_pattern
path_pattern: "Plugins/**/*.rb"
---

# Essentials Plugins Rules

## Plugin Structure

- Plugin folder structure: `Plugins/[PluginName]/[PluginName].rb`
- Plugin MUST have a header comment with name, author, version, description
- Plugin MUST NOT modify core Essentials scripts directly (use aliases)
- Plugin MUST be self-contained (no external dependencies beyond Essentials)
- Plugin MUST handle missing assets gracefully (use `pbResolveBitmap` to check)
- Plugin MUST NOT hardcode Pokémon IDs (use `:SPECIES` symbols instead)
- Plugin MUST NOT hardcode move IDs (use `:MOVE` symbols instead)
- Plugin MUST NOT hardcode item IDs (use `:ITEM` symbols instead)
- Plugin MUST use `EventHandlers.add(:hook_name, :id, proc { ... })` hooks when available (see wiki)
- Plugin MUST be compatible with save/load (test save scumming)

## Plugin Header Template

```ruby
#==============================================================================
# ** [PluginName]
#------------------------------------------------------------------------------
#  [Description]
#  Author: [YourName]
#  Version: [X.Y]
#  Compatibility: La Base de Sky v1.2+ / Pokémon Essentials v21.1
#==============================================================================
```

## Plugin Registration

```ruby
# At the top of your plugin file
if defined?(PluginManager)
  PluginManager.register(:MyPlugin, "1.0", "Description", "Author")
end
```

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
- `wiki-la-base-de-sky/wiki_markdown/08-Herramientas/plugins.md` — Plugin system
- `wiki-la-base-de-sky/wiki_markdown/08-Herramientas/scripts-utiles.md` — Useful script snippets
