# Actualizar La Base de Sky, los juegos ya creados, y el framework

Guía paso a paso para cuando sale una actualización de **La Base de Sky** (el motor/base) o de
su **wiki**, y hay que decidir qué hacer con: (1) el repo `wiki-la-base-de-sky`, (2) el repo
`la-base-de-sky` — tanto la rama `main` como cada `game/[nombre-del-juego]` ya en marcha —, y
(3) las reglas/agentes/docs de este framework (`game-studio-agents`) que asumen hechos sobre la
versión anterior.

Son **tres pasos independientes, en este orden**. No hace falta hacer los tres siempre: si solo
cambió la wiki (sin nueva versión del motor), el Paso 2 no aplica.

---

## Cuándo aplica esta guía

- `/setup-engine refresh` reporta que hay una versión nueva de La Base de Sky o de Pokémon
  Essentials disponible.
- Revisaste manualmente `wiki_markdown/09-Info/changelog.md` (o el repo/comunidad) y ves cambios.
- El autor de La Base de Sky publicó un nuevo release en `upstream` (GitLab del proyecto
  comunitario, no tu fork `origin`).

---

## Paso 1 — Actualizar `wiki-la-base-de-sky`

Este repo es solo documentación (markdown espejado de la wiki online). Actualízalo primero,
porque el Paso 3 depende de comparar la wiki vieja contra la nueva.

```bash
cd ../wiki-la-base-de-sky
python updater_wiki/descargar_wiki.py   # vuelve a descargar todas las páginas
git add -A
git commit -m "chore: actualizar wiki al estado de [fecha]"
git push
```

O simplemente pídeme **`/setup-engine refresh`** — hace esto por ti y te dice si hubo cambios
de versión.

**Antes de continuar al Paso 3**, guarda una referencia al commit anterior a esta actualización
(`git log --oneline -1 HEAD@{1}` o similar) — la necesitas para el diff dirigido del Paso 3.

---

## Paso 2 — Actualizar `la-base-de-sky` (el repo del juego)

Recuerda el modelo de 3 capas (`.claude/docs/technical-preferences.md` § Version Control
Strategy): `main` solo recibe de `upstream`, cada juego vive en `game/[nombre-del-juego]` y
nunca se fusiona a ningún lado, y `main` se fusiona HACIA los juegos, nunca al revés.

### 2.1 — Traer la actualización a `main`

```bash
cd ../la-base-de-sky
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

### 2.2 — Si es un cambio de versión (no solo parches menores)

Pídeme **`/setup-engine upgrade [versión-vieja] [versión-nueva]`**. Esto:
- busca la guía de migración entre versiones,
- audita `Plugins/` y `PBS/` en busca de campos/APIs deprecados,
- te muestra el hallazgo antes de tocar nada,
- actualiza `CLAUDE.md` con notas de migración tras tu confirmación.

### 2.3 — Propagar la actualización a cada juego ya creado

**Por cada** rama `game/[nombre-del-juego]` que ya exista:

```bash
git checkout game/[nombre-del-juego]
git merge main
```

- Resuelve conflictos manualmente si tu juego modificó algo que la actualización también tocó
  (lo más común: `PBS/*.txt` si el juego ya tiene especies/movimientos propios, o scripts core
  si el juego tiene `Data/Scripts/` extraído y editado).
- Corre **`/validate-pbs all`** después de resolver conflictos en PBS.
- Playtest en `Game.exe` antes de dar la actualización por buena.
- **Si hay epics en curso** (`epic/[epic-slug]` sin fusionar todavía a `game/[nombre-del-juego]`):
  avisa antes de tocarlos. Lo normal es esperar a que el epic termine y se fusione, y recién ahí
  actualizar `game/[nombre-del-juego]` con `main`. Si la actualización es urgente (p. ej. corrige
  un bug bloqueante), fusiona `main` a `game/[nombre-del-juego]` primero y luego fusiona
  `game/[nombre-del-juego]` hacia cada `epic/*` activo para que no diverjan — pregunta antes de
  hacer esto por ti mismo si tienes varios epics abiertos a la vez.

No hace falta repetir el Paso 2.2 (`/setup-engine upgrade`) por cada juego — el audit y las
notas de migración son a nivel de motor, no por juego.

---

## Paso 3 — Pedir a Claude Code que revise los cambios y los integre al framework

Este es el paso que no tiene un skill dedicado todavía (es el equivalente, en miniatura, de las
Fases 1-7 de `design/PLAN-IMPLEMENTACION-CC.md` que adaptaron el framework la primera vez). Se
hace pidiéndomelo directamente, con este patrón:

### 3.1 — Pide el diff dirigido de la wiki

```
Compara ../wiki-la-base-de-sky entre el commit [commit-viejo-del-Paso-1] y HEAD.
Dime qué páginas de wiki_markdown/ cambiaron de contenido (no solo de fecha).
```

Con `git -C ../wiki-la-base-de-sky diff --name-only [commit-viejo] HEAD` obtengo la lista real
de archivos cambiados — no me lo inventes de memoria.

### 3.2 — Mapea las páginas cambiadas a las partes del framework que las citan

Usa `.claude/docs/wiki-reference.md` (el índice agente↔wiki) y busca referencias literales:

```
Para cada página de wiki_markdown/ que cambió, busca (Grep) qué archivos de .claude/rules/,
.claude/agents/, .claude/docs/ y .claude/skills/ la citan. Esos son los únicos candidatos a
revisar — no toques nada que no referencie una página cambiada.
```

### 3.3 — Re-verifica cada candidato contra la wiki nueva y el código real

Para cada archivo candidato, pídeme que aplique la misma disciplina que se usó en la adaptación
original: **no confiar en el contenido anterior del archivo, releer la página de wiki actual y,
si aplica, el script/compilador real en `../la-base-de-sky`** antes de decidir si el archivo
sigue siendo correcto o necesita un cambio.

```
Para [archivo], compara contra wiki_markdown/[página].md (versión actual) y, si describe
sintaxis o una API, verifica también contra el código real en ../la-base-de-sky/.../Data/Scripts.
Dime si el archivo sigue siendo correcto, o qué cambiaría.
```

### 3.4 — Aprueba cambio por cambio

Igual que cualquier otro trabajo: te muestro el diff propuesto por archivo, pides confirmación
antes de escribir, y no hago commit salvo que lo pidas explícitamente (protocolo de
`docs/COLLABORATIVE-DESIGN-PRINCIPLE.md`).

### 3.5 — Deja rastro

Si el cambio es significativo (nueva versión de Essentials, cambio de formato PBS, API de
eventos nueva), vale la pena un resumen corto en `production/` (similar a
`production/verificacion-fase7.md`) con: versión anterior → nueva, archivos tocados, y qué se
verificó. No es obligatorio para un cambio menor de wiki.

---

## Checklist resumen

1. [ ] `/setup-engine refresh` (o Paso 1 manual) — wiki actualizada, versión detectada
2. [ ] Si hay nueva versión: `main ← upstream/main`, luego `/setup-engine upgrade` si aplica
3. [ ] Cada `game/[nombre-del-juego]` ← `main` (conflictos resueltos, `/validate-pbs all`, playtest)
4. [ ] Diff dirigido de la wiki + mapeo a archivos del framework que la citan
5. [ ] Re-verificación archivo por archivo contra wiki nueva + código real
6. [ ] Aprobación y (si se pide) commit

## Qué NO hacer

- No fusiones `game/[nombre-del-juego]` ni `epic/*` hacia `main` — nunca, bajo ninguna excusa de
  "sincronizar".
- No aceptes una regla/dato nuevo del framework solo porque la wiki lo dice — si toca sintaxis o
  una API, verifícalo también contra el código real (mismo principio que el caso
  `Evolution`/`Evolutions` en `.claude/rules/pbs-files.md`).
- No actualices epics en curso sin avisar — pregunta primero si hay `epic/*` sin fusionar.
- No re-adaptes todo el framework de cero (no repitas las Fases 1-7 completas) — el Paso 3 es
  deliberadamente dirigido solo a lo que cambió.

---

## Referencias

- `.claude/docs/technical-preferences.md` § Version Control Strategy — modelo de 3 capas de ramas
- `.claude/skills/setup-engine/SKILL.md` — `/setup-engine refresh` y `/setup-engine upgrade`
- `.claude/docs/wiki-reference.md` — índice agente ↔ página de wiki
- `design/PLAN-IMPLEMENTACION-CC.md` — el plan de adaptación original (referencia del nivel de
  rigor esperado al re-verificar)
- `production/verificacion-fase7.md` — ejemplo de reporte de verificación
