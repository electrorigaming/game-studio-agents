# Game Studio Agents — La Base de Sky

Framework multi-agente para **Claude Code** adaptado para diseñar y producir juegos Pokémon
fan-made sobre [La Base de Sky](https://skyfangames.blogspot.com/2024/01/base-de-sky.html)
(Pokémon Essentials v21.1/v22 en español, RPG Maker XP + mkxp-z, Ruby 3.1.3).

Convierte una sesión de Claude Code en un estudio de desarrollo completo: **49 agentes**
especializados (directores → leads → especialistas) y **~80 skills** (comandos slash) que
cubren desde la ideación del concepto hasta producción y release. Los especialistas de
Godot/Unity/Unreal de la plantilla original fueron deshabilitados y reemplazados por
especialistas de Essentials/Ruby/PBS.

> Adaptación de [Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)
> de Donchitos (MIT). El README original de la plantilla genérica está en la rama `main`.

## Qué hace este repo

Aquí se **diseña** (no se implementa): conceptos de juego, GDDs, arquitectura, epics,
stories y planificación. La implementación real (código Ruby, PBS, mapas, assets) ocurre en
el repo hermano `../la-base-de-sky`, guiada por los agentes de este framework.

| Repo hermano | Rol |
|--------------|-----|
| `../la-base-de-sky` | El juego real (motor + datos + assets) — donde se implementa |
| `../wiki-la-base-de-sky` | Documentación autorizada de implementación — los agentes la consultan antes de sugerir código |

## Instalación

1. Instala [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (CLI o app).
2. Clona los tres repos como carpetas hermanas bajo un mismo directorio:
   ```bash
   git clone https://github.com/electrorigaming/game-studio-agents.git
   git clone https://gitlab.com/electrorigaming/la-base-de-sky.git
   git clone https://github.com/electrorigaming/wiki-la-base-de-sky.git
   ```
3. En Windows, asegúrate de tener **Git Bash** (los hooks son scripts POSIX).
4. Abre Claude Code dentro de `game-studio-agents/`:
   ```bash
   cd game-studio-agents && claude
   ```

## Uso rápido

- **¿Primera sesión?** `/setup-essentials` (configura el proyecto) y luego `/start`
  (onboarding guiado).
- **Empezar un juego nuevo**: `/brainstorm` — crea automáticamente la rama permanente
  `game/[nombre-del-juego]` y guía la ideación hasta el documento de concepto.
- **¿Qué es cada cosa / dónde está documentado algo?** `/game-design-ia`
- **¿Perdido / qué sigue?** `/help`

Guía completa paso a paso: [`docs/GUIA-DE-USO.md`](docs/GUIA-DE-USO.md).
Documento maestro del proyecto: [`docs/GAME-DESIGN-IA.md`](docs/GAME-DESIGN-IA.md).

## Modelo de ramas (resumen)

- `main` — solo recibe de la plantilla genérica (`upstream`). No trabajar aquí.
- `adapted-essentials-oc` — la adaptación a La Base de Sky (solo archivos de framework).
- `game/[nombre-del-juego]` — una rama permanente por juego (diseño/producción de ese juego),
  creada desde `adapted-essentials-oc`. Nunca se fusiona a ningún lado.

Detalle completo: `.claude/docs/technical-preferences.md` § Version Control Strategy.
Actualizaciones (de La Base de Sky, la wiki o la plantilla):
`.claude/docs/actualizaciones-la-base-de-sky.md`.

## Licencia

MIT, igual que la plantilla original de [Donchitos](https://github.com/Donchitos/Claude-Code-Game-Studios).
