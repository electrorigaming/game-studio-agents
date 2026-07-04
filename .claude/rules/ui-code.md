---
trigger: path_pattern
path_pattern: "Plugins/**/UI_*.rb"
---

# UI Code Rules

## MUI (Modular UI) Framework

- Use MUI components when available instead of creating custom UI from scratch
- UI must NEVER own or directly modify game state — display only, use pb* functions to request changes
- All UI text must support Spanish characters (accents, ñ, ¿, ¡)
- Support keyboard input (arrow keys, Z/X/C for confirm/cancel/menu)
- All animations must be skippable and respect user motion/accessibility preferences
- UI sounds trigger through the audio system (pbSEPlay, pbBGMPlay)
- UI must never block the game thread

## RGSS-Specific Rules

- Always call `dispose` on Sprite, Viewport, Window objects when done
- Use `pbMessage(text)` for dialog, NOT `print` or `puts`
- Handle sprite caching to prevent memory leaks in long sessions
- Use Window_* classes for RPG Maker XP UI components
- Configure windowskins for different UI contexts (menus, dialog, battle)

## Reference Documentation

**MANDATORY**: Before implementing UI, consult:
- `../wiki-la-base-de-sky/wiki_markdown/04-Interfaz/mui-interfaz.md` — MUI system (CRITICAL)
- `../wiki-la-base-de-sky/wiki_markdown/04-Interfaz/menu-pausa.md` — Pause menu
- `../wiki-la-base-de-sky/wiki_markdown/04-Interfaz/pokedex.md` — Pokédex
- `../wiki-la-base-de-sky/wiki_markdown/04-Interfaz/mochila.md` — Bag system
