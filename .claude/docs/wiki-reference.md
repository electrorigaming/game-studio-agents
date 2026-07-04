# Wiki Reference Index

Quick reference for mapping agent domains to La Base de Sky wiki documentation.

**IMPORTANT**: Before suggesting implementations, agents MUST consult the relevant wiki sections. The wiki is the authoritative source for La Base de Sky implementation patterns.

---

## Pokémon Data (pbs-compiler-specialist, essentials-specialist)

### Species (`02-Pokemon/01-Pokemon/`)
- `definir-especie.md` — How to define a new Pokémon species in PBS
- `editar-pokemon.md` — How to edit existing Pokémon data
- `manipular-pokemon.md` — Manipulating Pokémon via script (add, remove, transform)
- `evolucion.md` — Evolution methods and custom evolutions
- `intercambio.md` — Trading Pokémon
- `pokemon-sombra.md` — Shadow/Dark Pokémon mechanics

### Moves (`02-Pokemon/02-Movimientos/`)
- `definir-movimiento.md` — How to define a new move in PBS
- `efectos-movimientos.md` — Move effect codes and battle effects
- `movimientos-campo.md` — Field moves (HM-like moves)
- `aprender-movimientos.md` — Move learning (level-up, TM, tutor)

### Abilities (`02-Pokemon/03-Habilidades/`)
- `habilidades.md` — Defining and implementing abilities

### Items (`02-Pokemon/04-Objetos/`)
- `objetos.md` — Item system overview
- `definir-objeto.md` — How to define a new item in PBS
- `efectos-objetos.md` — Item effects and handlers
- `manipular-objetos.md` — Adding/removing items via script
- `objetos-mapa.md` — Items on the map (pickups)
- `plantacion-bayas.md` — Berry planting system

---

## Battle System (essentials-specialist, gameplay-programmer)

### Battle Mechanics (`03-Combate/01-Combate/`)
- `combate.md` — Battle system overview
- `reglas-batalla.md` — Battle rules and formats
- `ronda-batalla.md` — Battle round structure
- `ia-batalla.md` — Battle AI and move selection
- `fondos-musica.md` — Battle backgrounds and music
- `animaciones-ataque.md` — Move animations
- `encuentros-salvajes.md` — Wild encounter setup
- `encuentros-evento.md` — Event-triggered encounters
- `encuentros-pesca.md` — Fishing encounters
- `nuevos-encuentros.md` — Custom encounter methods
- `pokemon-errantes.md` — Roaming Pokémon
- `gimnasio.md` — Gym battle setup
- `battle-frontier.md` — Battle Frontier facilities
- `desafio-batalla.md` — Battle challenge setup
- `revanchas.md` — Rematch system
- `pokeradar.md` — PokéRadar

### Trainers (`03-Combate/02-Personas/`)
- `entrenadores.md` — Trainer system overview
- `definir-entrenador.md` — How to define trainers in PBS
- `rival.md` — Rival configuration
- `entrenador-companero.md` — Partner/ally trainers
- `npcs-especiales.md` — Special NPCs
- `jugador.md` — Player configuration

### Features (`03-Combate/03-Caracteristicas/`)
- `buscasalvajes.md` — Wild Pokémon browser (Buscasalvajes)

---

## Interface (ui-programmer)

### Core UI (`04-Interfaz/`)
- `interfaz.md` — UI system overview
- `menu-pausa.md` — Pause menu customization
- `equipo-resumen.md` — Party and summary screens
- `pokedex.md` — Advanced Pokédex
- `mochila.md` — Bag/inventory system
- `pc-almacenamiento.md` — PC storage system
- `pokegear.md` — Pokégear
- `telefono.md` — Phone system
- `jukebox.md` — Jukebox
- `tarjeta-entrenador.md` — Trainer card
- `pantalla-opciones.md` — Options screen
- `opciones-paginas.md` — Paginated options menu
- `mui-interfaz.md` — **MUI (Modular UI) system** — CRITICAL for UI work
- `guardar-cargar.md` — Save/load system
- `menu-rapido.md` — Quick menu
- `mensajes.md` — Message/text system
- `audio.md` — Audio system

---

## World & Maps (level-designer)

### Maps (`05-Mundo/`)
- `mapas.md` — Map system overview
- `metadatos-mapa.md` — Map metadata (PBS/map_metadata.txt)
- `conectar-mapas.md` — Connecting maps (visual continuity)
- `transferencias-mapa.md` — Map transfers
- `tilesets.md` — Tileset configuration
- `obstaculos.md` — Obstacles and passability
- `puentes.md` — Bridge system
- `escaleras-laterales.md` — Lateral stairs
- `mazmorras.md` — Dungeon system
- `desplazamiento.md` — Movement/scrolling
- `tiempo.md` — Time system
- `clima.md` — Weather system

### Events (`05-Mundo/`)
- `eventos.md` — Event system (switches, variables, script calls)
- `eventos-temporales.md` — Timed events
- `controlar-eventos.md` — Controlling events via script

### Locations (`05-Mundo/`, `06-Ubicaciones/`)
- `mapas-ejemplo.md` — Example maps
- `carteles-ubicacion.md` — Location signs
- `intro-juego.md` — Game intro
- `elegir-inicial.md` — Starter selection
- `mapa-regional.md` — Regional map
- `centro-pokemon.md` — Pokémon Center
- `tienda-pokemon.md` — Poké Mart
- `salon-fama.md` — Hall of Fame

---

## Features (essentials-specialist)

### Game Features (`07-Caracteristicas/`)
- `regalo-misterioso.md` — Mystery Gift system
- `incubadora.md` — Egg incubator
- `guarderia-crianza.md` — Daycare and breeding
- `turbo.md` — Turbo/speed system
- `zona-safari.md` — Safari Zone
- `concurso-insectos.md` — Bug-catching contest
- `minijuegos.md` — Minigames

---

## Tools & Configuration (pbs-compiler-specialist, ruby-rgss-specialist)

### PBS & Data (`08-Herramientas/`)
- `pbs.md` — **PBS file format reference** — CRITICAL for data work
- `metadatos-globales.md` — Global metadata (metadata.txt)
- `definir-tipo.md` — Defining types
- `definir-cinta.md` — Defining ribbons
- `configuracion.md` — Game configuration/settings
- `compilador.md` — Compiler and build process

### Scripts (`08-Herramientas/`)
- `scripts-utiles.md` — Useful script snippets and utilities
- `secciones-scripts.md` — Script section ordering
- `debug.md` — Debug tools (F3 terminal, passability debug)
- `event-reporting.md` — Event reporting system
- `plugins.md` — **Plugin system** — CRITICAL for plugin development

---

## Info (`09-Info/`)
- `changelog.md` — Version changelog
- `creditos.md` — Credits

---

## Quick Reference by Agent

| Agent | Primary Wiki Sections |
|-------|----------------------|
| `essentials-specialist` | `08-Herramientas/`, `02-Pokemon/`, `03-Combate/` |
| `ruby-rgss-specialist` | `08-Herramientas/scripts-utiles.md`, `08-Herramientas/plugins.md`, `08-Herramientas/secciones-scripts.md` |
| `pbs-compiler-specialist` | `08-Herramientas/pbs.md`, `02-Pokemon/01-Pokemon/definir-especie.md`, `02-Pokemon/02-Movimientos/definir-movimiento.md` |
| `level-designer` | `05-Mundo/`, `06-Ubicaciones/` |
| `gameplay-programmer` | `03-Combate/`, `08-Herramientas/scripts-utiles.md` |
| `ui-programmer` | `04-Interfaz/`, especially `mui-interfaz.md` |
| `game-designer` | `02-Pokemon/`, `03-Combate/`, `07-Caracteristicas/` |
| `narrative-director` | `06-Ubicaciones/`, `05-Mundo/eventos.md` |
| `world-builder` | `05-Mundo/`, `06-Ubicaciones/` |

---

## Wiki Source

- **Online**: https://la-base-de-sky-wiki-1070f3.gitlab.io/
- **Local markdown**: `../wiki-la-base-de-sky/wiki_markdown/`
- **Scraper**: `../wiki-la-base-de-sky/updater_wiki/descargar_wiki.py`
