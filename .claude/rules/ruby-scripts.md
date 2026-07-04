---
trigger: path_pattern
path_pattern: "**/*.rb"
---

# Ruby/RGSS Scripts Rules

## Ruby Version Constraints

- ALL scripts run under the mkxp-z runtime on Ruby 3.1.3 (NOT classic RGSS/Ruby 1.9.3)
- Modern Ruby 3.x syntax (`->` lambdas, `**` kwargs, pattern matching) IS supported by the runtime,
  but the codebase convention is `proc { }` for blocks (0 occurrences of `->` found in
  `Data/Scripts/`) — match this convention for consistency unless there's a clear reason to deviate
- Use `define_method` for dynamic method creation

## Memory Management (CRITICAL)

- ALWAYS call `dispose` on `Sprite`, `Viewport`, `Window`, `Bitmap` objects when done
- Set disposed objects to `nil` after disposal
- Use `dispose` in `finalize` or explicit cleanup methods
- Watch for orphaned sprites in update loops

**Correct**:
```ruby
sprite = Sprite.new
sprite.bitmap = RPG::Cache.picture("my_image")
# ... use sprite ...
sprite.bitmap.dispose if sprite.bitmap
sprite.dispose
sprite = nil
```

**Incorrect** (memory leak):
```ruby
sprite = Sprite.new
sprite.bitmap = RPG::Cache.picture("my_image")
# ... use sprite ...
# VIOLATION: no dispose, memory leak!
```

## Method Aliasing

- Use `alias` for method overriding, NEVER monkey-patch core methods directly
- ALWAYS call the original method via the alias
- Name aliases descriptively: `alias mi_plugin_metodo_original metodo_original`

```ruby
class Game_Player
  alias mi_plugin_update update
  def update
    # Custom logic BEFORE original
    mi_plugin_custom_check
    # Call original
    mi_plugin_update
    # Custom logic AFTER original
    mi_plugin_post_update
  end
end
```

## Essentials API Patterns

- Use `pbMessage(text)` for dialog boxes, NOT `print` or `puts`
- Use `pbMessageDisplay(msg_window, text)` for multi-line messages (no `Kernel.` prefix — real usage in `Data/Scripts/` calls it directly)
- Use `EventHandlers.add(:hook_name, :id, proc { ... })` hooks instead of overriding core methods when possible
- Use `:SPECIES` symbols for Pokémon, `:MOVE` for moves, `:ITEM` for items
- Use `pbResolveBitmap(path)` to check if an asset exists before loading

## Performance

- Avoid creating objects in `update` methods (called every frame)
- Cache bitmaps and sprites when possible
- Use `Graphics.update` sparingly (prefer automatic updates)
- Avoid infinite loops in `Game_*` update methods
- Use `pbRNG.rand(n)` for random numbers in battle (deterministic for replays)

## Reference Documentation

**MANDATORY**: Before writing Ruby/RGSS code, consult:
- `../wiki-la-base-de-sky/wiki_markdown/08-Herramientas/scripts-utiles.md` — Useful script snippets
- `../wiki-la-base-de-sky/wiki_markdown/08-Herramientas/plugins.md` — Plugin system
- `../wiki-la-base-de-sky/wiki_markdown/08-Herramientas/secciones-scripts.md` — Script ordering
- `../wiki-la-base-de-sky/wiki_markdown/08-Herramientas/compilador.md` — Compilation process
