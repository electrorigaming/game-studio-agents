# Technical Preferences

<!-- Populated by /setup-engine. Updated as the user makes decisions throughout development. -->
<!-- All agents reference this file for project-specific standards and conventions. -->

## Version Control Strategy (la-base-de-sky game repo)

- **`main`** tracks `upstream/main` (the official La Base de Sky community repo) exclusively —
  it is updated ONLY by merging in upstream releases (via `/setup-engine upgrade` or
  `/setup-engine refresh`). Never commit any game design/content work to `main`, and never merge
  a game branch into it.
- **One permanent branch per game project**: all design/implementation for a given game lives on
  its own long-lived branch, `game/[nombre-del-juego]` (e.g. `game/mi-juego`). Every epic and
  story for that game (`/create-epics`, `/dev-story`, etc.) commits directly to this same branch
  — epics do NOT get their own sub-branch, and this branch is never merged anywhere. It IS the
  project, indefinitely.
- **Starting a second, independent game** in the same repo: create another branch from `main`,
  e.g. `game/mi-juego2`. Game branches never merge into each other or into `main`.
- **Picking up engine updates**: when `main` advances (new upstream release merged in), merge
  `main` INTO the game branch to bring in the update — never the other way around.
- `origin` is the user's own GitLab fork (`electrorigaming/la-base-de-sky`); `upstream` is the
  community repo (`la-base-de-sky/La-Base-de-Sky`). Push the game branch to `origin`.

## Engine & Language

- **Engine**: RPG Maker XP + Pokémon Essentials v21.1/v22, running on the mkxp-z runtime
- **Language**: Ruby 3.1.3 (verified via `x64-msvcrt-ruby310.dll` in the base install — NOT classic RGSS/Ruby 1.9.3)
- **Rendering**: N/A — mkxp-z's built-in 2D sprite/viewport renderer (no custom shader pipeline; `shader-code.md` rule was removed for this reason)
- **Physics**: N/A — no physics engine; RPG Maker XP uses tile-based grid movement and passability maps

## Input & Platform

- **Target Platforms**: PC (Windows) — mkxp-z build, single-player
- **Input Methods**: Keyboard/Mouse (arrow keys + Z/X/C for confirm/cancel/menu, per `ui-code.md`)
- **Primary Input**: Keyboard
- **Gamepad Support**: N/A — not part of the base mkxp-z configuration
- **Touch Support**: N/A — desktop-only
- **Platform Notes**: Windows-only distribution; hooks and scripts must run under Git Bash on Windows (verified in the Fase 1 diagnostic)

## Naming Conventions

- **PBS Files**: lowercase_snake_case.txt (`pokemon.txt`, `moves.txt`, `battle_facility_lists.txt`)
- **Ruby Scripts**: `NNN_Description.rb` (numeric prefix + descriptive name, e.g. `002_Overworld.rb`) — the prefix preserves script load order after extraction
- **Ruby Classes**: follow the class being extended — native RPG Maker classes use `Game_X`/`Scene_X`/`Window_X` (underscore-separated), Essentials-added classes use plain PascalCase (e.g. `PokemonGlobalMetadata`)
- **Graphics/**: subfolders by asset type — `Animations/`, `Autotiles/`, `Battle animations/`, `Battlebacks/`, `Characters/`, `Fogs/`, `Icons/`, `Items/`, `Pictures/`, `Pokemon/`, `Tilesets/`, `Titles/`, `Trainers/`, `Transitions/`, `UI/`, `Weather/`, `Windowskins/`
- **Audio/**: `BGM/`, `ME/`, `SE/` (no `BGS/` subfolder in this base — verified against the real install)
- **Plugins**: `Plugins/[PluginName]/[PluginName].rb`

## Performance Budgets

- **Target Framerate**: N/A — not tracked; mkxp-z targets the RPG Maker XP default (~40 FPS internal tick)
- **Frame Budget**: N/A — no per-frame profiling infrastructure in this project
- **Draw Calls**: N/A — not a concept exposed by mkxp-z's fixed sprite/viewport pipeline
- **Memory Ceiling**: N/A — no memory budget defined; the practical concern is `dispose` discipline on `Sprite`/`Viewport`/`Window`/`Bitmap` (see `ruby-scripts.md`), not a numeric ceiling

## Testing

- **Framework**: None — RGSS/mkxp-z has no unit test harness; verification is manual (`Game.exe` playtesting) plus the deterministic `scripts/validate_pbs.rb` for PBS data
- **Minimum Coverage**: N/A — no automated coverage tracking
- **Required Tests**: `/validate-pbs` after any PBS data change; manual playtest after any script combine (`/combine-scripts`)

## Forbidden Patterns

<!-- Add patterns that should never appear in this project's codebase -->
- [None configured yet — add as architectural decisions are made]

## Allowed Libraries / Addons

<!-- Add approved third-party dependencies here -->
- [None configured yet — add as dependencies are approved]

## Architecture Decisions Log

<!-- Quick reference linking to full ADRs in docs/architecture/ -->
- [No ADRs yet — use /architecture-decision to create one]

## Engine Specialists

<!-- Written by /setup-engine when engine is configured. -->
<!-- Read by /code-review, /architecture-decision, /architecture-review, and team skills -->
<!-- to know which specialist to spawn for engine-specific validation. -->

- **Primary**: `essentials-specialist`
- **Language/Code Specialist**: `ruby-rgss-specialist`
- **Shader Specialist**: N/A — no shader pipeline (see Rendering above)
- **UI Specialist**: `ui-programmer` (MUI / Modular UI)
- **Additional Specialists**: `pbs-compiler-specialist` (PBS data), `level-designer` (maps/events)
- **Routing Notes**: `lead-programmer` coordinates all three Essentials specialists; escalate
  engine-architecture decisions to `technical-director`

### File Extension Routing

| File Extension / Type | Specialist to Spawn |
|-----------------------|---------------------|
| PBS data files (`PBS/*.txt`) | `pbs-compiler-specialist` |
| Ruby scripts (`**/*.rb`) | `ruby-rgss-specialist` |
| Plugin code (`Plugins/**/*.rb`) | `ruby-rgss-specialist` |
| Event script calls (proposed for RPG Maker's event editor) | `level-designer` |
| Map data (`Data/Map*.rxdata`) | `level-designer` |
| UI / MUI screens | `ui-programmer` |
| Graphics/Audio assets | `essentials-specialist` |
| Shader / material files | N/A — no shader pipeline |
| General architecture review | Primary (`essentials-specialist`) |
