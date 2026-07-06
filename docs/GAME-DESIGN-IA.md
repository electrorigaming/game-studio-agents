# Game-Design-IA — Documento Maestro

Referencia consolidada del proyecto **Game-Design-IA**: qué es, cómo se relacionan sus tres
repositorios, qué modelo de ramas usa cada uno, y dónde está documentado cada tema.

Este documento **no duplica** el contenido de los documentos canónicos — los indexa y remite
a ellos. La única información que vive aquí de forma original es la tabla consolidada del
modelo de ramas de los tres repos (sección 3). Para regenerarlo tras cambios grandes:
`/game-design-ia update`.

> Vista general del workspace (estructura, convenciones críticas, fuentes autorizadas,
> qué evitar): ver `../AGENTS.md` (raíz de `Game Design IA/game-design-ia/`).

---

## 1. Qué es Game-Design-IA

Un workspace para diseñar y desarrollar juegos Pokémon fan-made sobre **La Base de Sky**
(Pokémon Essentials v21.1/v22 en español, RPG Maker XP + mkxp-z, Ruby 3.1.3), usando
**Claude Code** como estudio de desarrollo multi-agente: 49 agentes especializados y ~80
skills que cubren desde la ideación del concepto hasta producción y release.

El framework de agentes (`game-studio-agents`) es una adaptación de la plantilla genérica
[Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios) — los
especialistas de Godot/Unity/Unreal fueron deshabilitados (`.claude/agents/disabled/`) y
reemplazados por especialistas de Essentials/Ruby/PBS.

## 2. Los tres repositorios

| Repo | Rol | `origin` | `upstream` |
|------|-----|----------|------------|
| `game-studio-agents/` | El framework de agentes/skills (este repo). Aquí se diseña: GDDs, arquitectura, epics, stories | `github.com/electrorigaming/game-studio-agents` | `github.com/Donchitos/Claude-Code-Game-Studios` (plantilla genérica) |
| `la-base-de-sky/` | El juego real: motor, PBS, scripts Ruby, Graphics/Audio. Aquí se implementa | `gitlab.com/electrorigaming/la-base-de-sky` | `gitlab.com/la-base-de-sky/La-Base-de-Sky` (comunidad) |
| `wiki-la-base-de-sky/` | Documentación autorizada de implementación (markdown local de la wiki oficial) | `github.com/electrorigaming/wiki-la-base-de-sky` | *(no tiene — se actualiza con el scraper `updater_wiki/descargar_wiki.py`)* |

Regla de confianza (de `../AGENTS.md`): wiki > código real de La Base de Sky > definiciones
del framework > READMEs. Los agentes consultan la wiki **antes** de sugerir implementaciones
(índice de mapeo: `.claude/docs/wiki-reference.md`).

## 3. Modelo de ramas consolidado

Los dos repos con trabajo activo usan el mismo patrón: una base estable que solo recibe de
su `upstream`, y ramas permanentes por juego que nunca se fusionan a ningún lado.
Las actualizaciones siempre fluyen **hacia abajo** (base → juego), nunca al revés.

| Capa | `la-base-de-sky` | `game-studio-agents` |
|------|------------------|----------------------|
| Base que sigue a `upstream` | `main` ← comunidad La Base de Sky | `main` ← plantilla genérica (Donchitos) |
| Capa de adaptación | *(no existe)* | `adapted-essentials-oc` — la adaptación a Essentials; **solo archivos de framework** (`.claude/**`, `CLAUDE.md`, docs de framework). Nunca se fusiona a `main` |
| Rama permanente por juego | `game/[nombre]` (desde `main`) — el código del juego | `game/[nombre]` (desde `adapted-essentials-oc`) — `design/`, `production/`, `docs/architecture/`, `docs/custom-extensions/` de ese juego. La crea `/brainstorm` automáticamente |
| Ramas de trabajo | `epic/[slug]` (desde la rama de juego; al terminar se fusiona **de vuelta a la rama de juego**, nunca a `main`) | *(no se usan — se trabaja directo en la rama de juego)* |

Reglas clave (detalle completo: `.claude/docs/technical-preferences.md` § Version Control
Strategy, ambas secciones):

- Nunca commitear contenido de juego en `main` de ningún repo.
- Un segundo juego independiente = otra rama `game/[nombre2]` desde la misma base. Las ramas
  de juego nunca se fusionan entre sí.
- Recoger una actualización = fusionar la base **hacia** la rama de juego
  (`git merge main` en la-base-de-sky; `git merge adapted-essentials-oc` en
  game-studio-agents), nunca al revés.

## 4. Flujo de trabajo (fases)

Resumen: Concepto (`/brainstorm` → `/prototype` → `/art-bible` → `/map-systems` →
`/design-system` → `/review-all-gdds` → `/gate-check`) → Arquitectura
(`/create-architecture` → `/architecture-decision` → `/create-control-manifest` →
`/architecture-review`) → Pre-producción (`/ux-design` → `/vertical-slice` →
`/create-epics` → `/create-stories` → `/sprint-plan`) → Producción (`/dev-story` →
`/code-review` → `/story-done`, por epic en `epic/[slug]` dentro de la-base-de-sky).

- **Guía completa paso a paso**: `docs/GUIA-DE-USO.md` (9 secciones)
- **Versión web (Artifact)**: https://claude.ai/code/artifact/1e1fe080-8828-4eab-84d5-8cb93210a655
- **¿Primera sesión?** `/setup-essentials` y luego `/start`. **¿Perdido?** `/help`

## 5. Actualizaciones

Dos disparadores independientes — guía completa:
`.claude/docs/actualizaciones-la-base-de-sky.md`:

1. **Cambió La Base de Sky o su wiki** → Pasos 1-3: actualizar la wiki (scraper), fusionar
   `upstream/main` → `main` → cada `game/*` en la-base-de-sky, y pedir a Claude Code que
   revise el diff de la wiki e integre los cambios relevantes al framework.
2. **Cambió la plantilla genérica** (upstream de game-studio-agents) → Paso 4: fusionar a
   `main`, clasificar los cambios (específicos de Godot/Unity/Unreal → ignorar/`disabled/`;
   genéricos → evaluar), fusionar lo aceptado a `adapted-essentials-oc` y propagar a cada
   `game/*`. Referencia de clasificación: `UPGRADING.md`.

## 6. Índice de documentos canónicos

| Documento | Qué contiene | Cuándo consultarlo |
|-----------|--------------|--------------------|
| `../AGENTS.md` (workspace) | Estructura de los 3 repos, convenciones críticas, fuentes autorizadas | Orientación general del workspace |
| `CLAUDE.md` | Configuración maestra del framework: stack, protocolo de colaboración, guías de comportamiento | Siempre cargado — punto de entrada |
| `docs/GUIA-DE-USO.md` | Guía de uso completa: fases, skills por fase, ramas, notas prácticas, actualizaciones | Cómo usar el framework día a día |
| `.claude/docs/actualizaciones-la-base-de-sky.md` | Guía paso a paso de actualizaciones (los 4 pasos, checklists, qué NO hacer) | Cuando hay versión nueva de La Base de Sky, la wiki o la plantilla |
| `.claude/docs/technical-preferences.md` | Modelo de ramas de ambos repos, stack técnico, convenciones de nombres, ruteo de especialistas | Decisiones técnicas, qué rama usar, qué agente toca qué archivo |
| `.claude/docs/wiki-reference.md` | Mapa página-de-wiki → dominio de agente | Antes de implementar cualquier cosa en el juego |
| `.claude/docs/coordination-rules.md` | Jerarquía de agentes, tiers de modelo, subagentes vs equipos | Cómo se coordinan/escalan los agentes |
| `.claude/docs/coding-standards.md` | Estándares de código, formato de GDD (8 secciones), evidencia de tests por tipo de story | Al escribir código, GDDs o tests |
| `.claude/docs/context-management.md` | Estado en archivo (`production/session-state/active.md`), compactación, recuperación de sesión | Sesiones largas o tras un crash |
| `.claude/docs/directory-structure.md` | Estructura de directorios del framework | Dónde va cada artefacto |
| `.claude/rules/*.md` | Reglas por tipo de archivo: PBS, Ruby/RGSS, eventos, plugins, UI, gameplay | Antes de tocar ese tipo de archivo |
| `docs/COLLABORATIVE-DESIGN-PRINCIPLE.md` | Protocolo Pregunta → Opciones → Decisión → Borrador → Aprobación | Cómo trabajan los agentes contigo |
| `UPGRADING.md` | Tablas por versión de la plantilla genérica: qué sobrescribir vs fusionar con cuidado | Paso 4 de actualizaciones |
| `production/diagnostico-essentials.md`, `production/verificacion-fase7.md` | Verificación de la adaptación misma (no de un juego) | Auditar qué se verificó al adaptar el framework |
| `scripts/validate_pbs.rb` | Validador determinista de PBS (lo usa `/validate-pbs`) | Tras cualquier cambio de datos PBS |

## 7. Historial de cambios

No hay changelog propio — el historial vive en git:

```bash
# Evolución de la adaptación del framework
git log --oneline adapted-essentials-oc

# Trabajo de un juego concreto (diseño)
git log --oneline game/[nombre] --not adapted-essentials-oc

# En la-base-de-sky: trabajo de un juego (código)
git log --oneline game/[nombre] --not main
```
